/// The concrete connection controller implementation.
library;

import 'dart:async';
import 'dart:collection';

import 'archipelago_client_settings.dart';
import 'archipelago_connector.dart';
import 'archipelago_room_info.dart';
import 'data_storage.dart';
import 'protocol_types/general_types.dart';
import 'protocol_types/client_to_server.dart';
import 'protocol_types/server_to_client.dart';
import 'consts.dart';
import 'user_types.dart';

// TODO: Document more
/// Controller class for an Archipelago connection.
class ArchipelagoClient {
  final ArchipelagoProtocolConnection _connection;
  final ArchipelagoClientSettings _clientSettings;
  final ArchipelagoDataStorage _storage;
  final ArchipelagoRoomInfo _roomInfo;
  final StreamController<ServerMessage> _streamController;

  /// A stream of messages from an archipelago server.
  Stream<ArchipelagoEvent> get stream =>
      _streamController.stream
          .map((e) => _convert(e))
          .where((e) => e != null)
          .cast();

  Permission get releasePermission => _roomInfo.releasePermission;
  Permission get collectPermission => _roomInfo.collectPermission;
  Permission get remainingPermission => _roomInfo.remainingPermission;
  List<String> get roomTags => _roomInfo.tags;
  int get hintCost => _roomInfo.hintCost;

  List<String> get clientTags => _clientSettings.tags;

  bool get receiveOtherWorld => _clientSettings.receiveOtherWorlds;
  bool get receiveOwnWorld => _clientSettings.receiveOwnWorld;
  bool get receiveStartingInventory => _clientSettings.receiveStartingInventory;

  bool get connected => _connection.connected;

  List<Player> get players =>
      _roomInfo.players.map((e) => Player(e.name, e.slot)).toList();

  ArchipelagoClient._(
    this._connection,
    this._clientSettings,
    this._roomInfo,
    this._storage,
    this._streamController,
  );

  static Future<ArchipelagoClient> connectWithConnector({
    required ArchipelagoProtocolConnector connector,
    required String name,
    required String uuid,
    ArchipelagoDataStorage? storage,
    List<String> tags = const [],
    String? game,
    String? password,
    bool receiveOtherWorlds = false,
    bool receiveOwnWorld = false,
    bool receiveStartingInventory = false,
    bool receiveSlotData = false,
  }) async {
    final clientSettings = ArchipelagoClientSettings(
      name: name,
      uuid: uuid,
      game: game,
      password: password,
      tags: tags,
      receiveOtherWorlds: receiveOtherWorlds,
      receiveOwnWorld: receiveOwnWorld,
      receiveStartingInventory: receiveStartingInventory,
      receiveSlotData: receiveSlotData,
    );

    ArchipelagoDataStorage store;
    if (storage == null) {
      store = ArchipelagoDataStorage(<String, ArchipelagoGame>{});
    } else {
      store = storage;
    }

    ArchipelagoProtocolConnection connection = await connector.connect();
    return await ArchipelagoClient._handshake(
      connection,
      clientSettings,
      store,
    );
  }

  static Future<ArchipelagoClient> connect({
    required String host,
    required int port,
    required String name,
    required String uuid,
    ArchipelagoDataStorage? storage,
    List<String> tags = const [],
    String? game,
    String? password,
    bool receiveOtherWorlds = false,
    bool receiveOwnWorld = false,
    bool receiveStartingInventory = false,
    bool receiveSlotData = false,
  }) async {
    final clientSettings = ArchipelagoClientSettings(
      name: name,
      uuid: uuid,
      game: game,
      password: password,
      tags: tags,
      receiveOtherWorlds: receiveOtherWorlds,
      receiveOwnWorld: receiveOwnWorld,
      receiveStartingInventory: receiveStartingInventory,
      receiveSlotData: receiveSlotData,
    );

    ArchipelagoDataStorage store;
    if (storage == null) {
      store = ArchipelagoDataStorage(<String, ArchipelagoGame>{});
    } else {
      store = storage;
    }

    ArchipelagoProtocolConnector connector = ArchipelagoProtocolConnector(
      host,
      port,
    );

    ArchipelagoProtocolConnection connection = await connector.connect();
    return await ArchipelagoClient._handshake(
      connection,
      clientSettings,
      store,
    );
  }

  static Future<ArchipelagoClient> _handshake(
    ArchipelagoProtocolConnection connection,
    ArchipelagoClientSettings clientSettings,
    ArchipelagoDataStorage storage,
  ) async {
    final StreamController<ServerMessage> controller = StreamController();
    final _MessageQueue<ServerMessage> handshakeQueue = _MessageQueue();
    bool doQueue = true;

    //TODO: handle this better
    connection.stream.listen((event) {
      if (doQueue) {
        handshakeQueue.addMessage(event);
      }
      controller.add(event);
    });

    final ServerMessage roomInfoMessage = await handshakeQueue.getMessage();
    if (roomInfoMessage is! RoomInfoMessage) {
      throw HandshakeException('RoomInfo', roomInfoMessage);
    }

    final Map<String, String> checksums = storage.games.map(
      (key, value) => MapEntry(key, value.checksum),
    );
    final List<String> gamesToGet =
        roomInfoMessage.datapackageChecksums.entries
            .where(
              (entry) =>
                  checksums[entry.key] != entry.value ||
                  !checksums.keys.contains(entry.key),
            )
            .map((e) => e.key)
            .toList();
    if (gamesToGet.isNotEmpty) {
      connection.send(GetDataPackageMessage(gamesToGet));
      final ServerMessage dataPackage = await handshakeQueue.getMessage();
      if (dataPackage is! DataPackageMessage) {
        throw HandshakeException('DataPackage', dataPackage);
      }
      dataPackage.data.games.forEach(
        (key, value) => storage.updateGame(
          key,
          ArchipelagoGame(
            value.itemNameToId,
            value.locationNameToId,
            value.checksum,
          ),
        ),
      );
      storage.save();
    }

    connection.send(
      ConnectMessage(
        roomInfoMessage.password ? clientSettings.password : null,
        clientSettings.game,
        clientSettings.name,
        clientSettings.uuid,
        ArchipelagoGlobal.supportedVersion,
        clientSettings.receiveOtherWorlds,
        clientSettings.receiveOwnWorld,
        clientSettings.receiveStartingInventory,
        clientSettings.tags,
        clientSettings.receiveSlotData,
      ),
    );

    final ServerMessage connectedMessage = await handshakeQueue.getMessage();
    // Stop sending messages to the queue, we've either succeeded or failed by now.
    doQueue = false;

    if (connectedMessage is ConnectionRefusedMessage) {
      throw ArchipelagoConnectionRefused(connectedMessage.errors);
    } else if (connectedMessage is! ConnectedMessage) {
      throw HandshakeException('Connected', connectedMessage);
    }

    final ArchipelagoRoomInfo roomInfo = ArchipelagoRoomInfo(
      connectedMessage.players,
      connectedMessage.team,
      connectedMessage.slot,
      connectedMessage.slotData,
      connectedMessage.slotInfo,
      connectedMessage.hintPoints,
      connectedMessage.checkedLocations,
      connectedMessage.missingLocations,
      roomInfoMessage.tags,
      roomInfoMessage.password,
      roomInfoMessage.permissions,
      roomInfoMessage.hintCost,
      roomInfoMessage.locationCheckPoints,
      roomInfoMessage.games,
      roomInfoMessage.datapackageChecksums,
      roomInfoMessage.seedName,
      roomInfoMessage.time,
    );
    return ArchipelagoClient._(
      connection,
      clientSettings,
      roomInfo,
      storage,
      controller,
    );
  }

  ArchipelagoEvent? _convert(ServerMessage message) {
    switch (message) {
      case ReceivedItemsMessage():
        final List<SentItem> items =
            message.items.map((e) {
              // TODO: Improve null checking
              final player = _roomInfo.resolvePlayer(e.player, _roomInfo.team);
              final slotInfo = _roomInfo.resolveSlot(e.player);
              final game = slotInfo?.name;
              final itemName = _storage.resolveItemId(game!, e.item);
              final locationName = _storage.resolveLocationId(game, e.location);
              return SentItem(
                Location(locationName!, e.location),
                Item(
                  itemName!,
                  e.item,
                  e.flags.logicalAdvancement,
                  e.flags.useful,
                  e.flags.trap,
                ),
                Player(player!.alias, player.slot),
              );
            }).toList();
        return ItemsReceived(items, message.index);
      case LocationInfoMessage():
        final List<SentItem> scouts =
            message.locations.map((e) {
              final slotInfo = _roomInfo.resolveSlot(e.player);
              final player = _roomInfo.resolvePlayer(e.player, _roomInfo.team);
              final itemName = _storage.resolveItemId(slotInfo!.game, e.item);
              final locationName = _storage.resolveLocationId(
                slotInfo.game,
                e.location,
              );
              return SentItem(
                Location(locationName!, e.location),
                Item(
                  itemName!,
                  e.item,
                  e.flags.logicalAdvancement,
                  e.flags.useful,
                  e.flags.trap,
                ),
                Player(player!.alias, e.player),
              );
            }).toList();
        return LocationsScouted(scouts);
      case RoomUpdateMessage():
        return RoomUpdate(message);
      case PrintJSONMessage():
        return _jsonMessageToDisplayMessage(message);
      case BouncedMessage():
        return Bounced(
          games: message.games,
          players:
              message.slots
                  ?.map(
                    (e) => Player(
                      _roomInfo.resolvePlayer(e, _roomInfo.team)!.alias,
                      e,
                    ),
                  )
                  .toList(),
          tags: message.tags,
          data: message.data,
        );
      case InvalidPacketMessage():
        return InvalidPacket(message.type.name, message.cmd, message.text);
      case RetrievedMessage():
        return DataRetrieved(message.keys);
      case SetReplyMessage():
        return SetDataReply(
          message.key,
          message.value,
          message.originalValue,
          message.slot,
        );
      default:
        return null;
    }
  }

  MessagePart _convertJSONMessagePart(JSONMessagePart part) {
    switch (part) {
      case TextJSONMessagePart():
        return TextMessagePart(part.text);
      case PlayerIDJSONMessagePart():
        final id = int.parse(part.text);
        return PlayerMessagePart(
          Player(_roomInfo.resolvePlayer(id, _roomInfo.team)!.alias, id),
        );
      case PlayerNameJSONMessagePart():
        return PlayerMessagePart(Player(part.text));
      case ItemIDJSONMessagePart():
        final game = _roomInfo.resolveSlot(part.player)!.game;
        final id = int.parse(part.text);
        return ItemMessagePart(
          Item(
            _storage.resolveItemId(game, id)!,
            id,
            part.flags.logicalAdvancement,
            part.flags.useful,
            part.flags.trap,
          ),
        );
      case ItemNameJSONMessagePart():
        // TODO: Handle this case.
        // this is only in reference clients for the current version
        throw UnimplementedError();
      case LocationIDJSONMessagePart():
        final game = _roomInfo.resolveSlot(part.player)!.game;
        final id = int.parse(part.text);
        return LocationMessagePart(
          Location(_storage.resolveLocationId(game, id)!, id),
        );
      case LocationNameJSONMessagePart():
        // TODO: Handle this case.
        // this is only in reference clients for the current version
        throw UnimplementedError();
      case EntranceNameJSONMessagePart():
        return EntranceMessagePart(Entrance(part.text));
      case HintStatusJSONMessagePart():
        return HintStatusPart(part.text, part.status);
      case ColorJSONMessagePart():
        return ColorMessagePart(part.text, part.color);
    }
  }

  /// Apply a RoomUpdate.
  void applyRoomUpdate(RoomUpdate update) {
    _updateRoomInfo(update.update);
  }

  /// Update the room info.
  void _updateRoomInfo(RoomUpdateMessage update) {
    _roomInfo.updateRoomInfo(
      checkedLocations: update.checkedLocations,
      players: update.players,
      tags: update.tags,
      password: update.password,
      permissions: update.permissions,
      hintCost: update.hintCost,
      locationCheckPoints: update.locationCheckPoints,
      games: update.games,
      datapackageChecksums: update.datapackageChecksums,
      seedName: update.seedName,
      time: update.time,
    );
  }

  void modifyClientSettings({
    List<String>? tags,
    bool? receiveOtherWorlds,
    bool? receiveOwnWorld,
    bool? receiveStartingInventory,
  }) {
    _clientSettings.setItemHandlingFlags(
      receiveOtherWorlds ?? _clientSettings.receiveOtherWorlds,
      receiveOwnWorld ?? _clientSettings.receiveOwnWorld,
      receiveStartingInventory ?? _clientSettings.receiveStartingInventory,
    );
    if (tags != null) _clientSettings.tags = tags;
    _send(
      ConnectUpdateMessage(
        _clientSettings.receiveOtherWorlds,
        _clientSettings.receiveOwnWorld,
        _clientSettings.receiveStartingInventory,
        _clientSettings.tags,
      ),
    );
  }

  void checkLocations(List<int> locations) {
    _send(LocationChecksMessage(locations));
  }

  void sync() {
    _send(SyncMessage());
  }

  void scoutLocations(List<int> locations, bool asHint, bool newHintsOnly) {
    int value = 0;
    if (asHint) {
      if (newHintsOnly) {
        value = 2;
      } else {
        value = 1;
      }
    }
    _send(LocationScoutsMessage(locations, value));
  }

  void updateHint(int player, int location, HintStatus status) {
    _send(UpdateHintMessage(player, location, status));
  }

  void clientStatus(ClientStatus status) {
    _send(StatusUpdateMessage(status));
  }

  void say(String message) {
    _send(SayMessage(message));
  }

  void getDataPackage(DataPackageHandler handler, List<String>? games) {
    _send(GetDataPackageMessage(games));
  }

  void bounce(
    Map<dynamic, dynamic> data,
    List<String>? games,
    List<int>? slots,
    List<String>? tags,
  ) {
    _send(BounceMessage(data: data, games: games, slots: slots, tags: tags));
  }

  void getStorage(List<String> keys) {
    _send(GetMessage(keys));
  }

  /// Send a message to the server.
  void _send(ClientMessage message) {
    _connection.send(message);
  }

  DisplayMessage _jsonMessageToDisplayMessage(PrintJSONMessage message) {
    final parts = message.data.map(_convertJSONMessagePart).toList();
    final receivingID = message.receiving;
    final networkItem = message.item;
    final Player? receivingPlayer =
        receivingID == null
            ? null
            : _roomInfo.resolveUserPlayer(receivingID, _roomInfo.team);
    final SentItem? sentItem =
        networkItem == null ? null : _createSentItem(networkItem);
    final int? slot = message.slot;
    final int? team = message.team;
    final Player? player =
        (slot != null && team != null)
            ? _roomInfo.resolveUserPlayer(slot, team)
            : null;
    final List<String>? tags = message.tags;
    switch (message.type) {
      case null:
        return DisplayMessage(parts);
      case PrintJSONType.itemsend:
        return ItemSend(parts, receivingPlayer!, sentItem!);
      case PrintJSONType.itemcheat:
        return ItemCheat(parts, receivingPlayer!, sentItem!);
      case PrintJSONType.hint:
        final bool found = message.found!;
        return HintMessage(parts, receivingPlayer!, sentItem!, found);
      case PrintJSONType.join:
        return PlayerJoined(parts, player!, tags!);
      case PrintJSONType.tagsChanged:
        return TagsChanged(parts, player!, tags!);
      case PrintJSONType.part:
        return PlayerLeft(parts, player!);
      case PrintJSONType.chat:
        final String chatMessage = message.message!;
        return ChatMessage(parts, player!, chatMessage);
      case PrintJSONType.goal:
        return GoalReached(parts, player!);
      case PrintJSONType.release:
        return ItemsReleased(parts, player!);
      case PrintJSONType.collect:
        return ItemsCollected(parts, player!);
      case PrintJSONType.serverChat:
        return ServerChatMessage(parts, message.message!);
      case PrintJSONType.tutorial:
        return TutorialMessage(parts);
      case PrintJSONType.commandResult:
        return CommandResult(parts);
      case PrintJSONType.adminCommandResult:
        return AdminCommandResult(parts);
      case PrintJSONType.countdown:
        return CountdownMessage(parts, message.countdown!);
    }
  }

  Location _resolveLocation(int playerSlot, int locationID) {
    final NetworkSlot slot = _roomInfo.resolveSlot(playerSlot)!;
    final String locationName =
        _storage.resolveLocationId(slot.game, locationID)!;
    return Location(locationName, locationID);
  }

  Item _resolveItem(NetworkItem item, [bool isForLocationInfo = false]) {
    final String game;
    if (isForLocationInfo) {
      game = _roomInfo.resolveSlot(item.player)!.game;
    } else {
      game = _roomInfo.resolveSlot(_roomInfo.slot)!.game;
    }
    final String name = _storage.resolveItemId(game, item.item)!;
    return Item(
      name,
      item.item,
      item.flags.logicalAdvancement,
      item.flags.useful,
      item.flags.trap,
    );
  }

  SentItem _createSentItem(NetworkItem item, [bool isForLocationInfo = false]) {
    final Location location;
    final Player player = _roomInfo.resolveUserPlayer(
      item.player,
      _roomInfo.team,
    );
    if (isForLocationInfo) {
      location = _resolveLocation(_roomInfo.slot, item.location);
    } else {
      location = _resolveLocation(item.player, item.location);
    }
    return SentItem(location, _resolveItem(item, isForLocationInfo), player);
  }
}

/// A queue to hold messages and return them asynchronously.
/// ONLY USE DURING THE HANDSHAKE.
class _MessageQueue<T> {
  final Queue<T> _queue = Queue<T>();
  Completer<T>? _waiting;

  void addMessage(T message) {
    if (_waiting == null) {
      _queue.add(message);
    } else {
      _waiting!.complete(message);
      _waiting = null;
    }
  }

  Future<T> getMessage() async {
    if (_queue.isEmpty) {
      // This doesn't actually make anything safer
      _waiting ??= Completer();
      return _waiting!.future;
    } else {
      return Future.value(_queue.removeFirst());
    }
  }
}

abstract interface class DataPackageHandler {
  List<String>? selectGames(RoomInfoMessage roomInfo);
  Future<void> handleDataPackage(DataPackageMessage dataPackage);
}

class HandshakeException implements Exception {
  final String expected;
  final ServerMessage received;
  HandshakeException(this.expected, this.received);

  @override
  String toString() {
    return 'Handshake Exception: Expected $expected. Received $received';
  }
}

class ArchipelagoConnectionRefused implements Exception {
  final List<ConnectionRefusedReason>? errors;
  ArchipelagoConnectionRefused(this.errors);
}

extension _ResolveUserPlayer on ArchipelagoRoomInfo {
  Player resolveUserPlayer(int playerID, int teamID) {
    final networkPlayer = resolvePlayer(playerID, teamID)!;
    return Player(networkPlayer.alias, playerID);
  }
}
