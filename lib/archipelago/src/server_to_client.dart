/// All the message types that can be sent form the server to the client.
library;

import 'package:json_annotation/json_annotation.dart';

import 'protocol_types.dart';

part 'server_to_client.g.dart';

sealed class ServerMessage {
  abstract final String cmd;
  static ServerMessage fromJson(Map<String, dynamic> json) {
    final String cmd = json['cmd'];
    switch (cmd) {
      case 'RoomInfo':
        return RoomInfoMessage.fromJson(json);
      case 'ConnectionRefused':
        return ConnectionRefusedMessage.fromJson(json);
      case 'Connected':
        return ConnectedMessage.fromJson(json);
      case 'ReceivedItems':
        return ReceivedItemsMessage.fromJson(json);
      case 'LocationInfo':
        return LocationInfoMessage.fromJson(json);
      case 'RoomUpdate':
        return RoomUpdateMessage.fromJson(json);
      case 'PrintJSON':
        return PrintJSONMessage.fromJson(json);
      case 'DataPackage':
        return DataPackageMessage.fromJson(json);
      case 'Bounced':
        return BouncedMessage.fromJson(json);
      case 'InvalidPacket':
        return InvalidPacketMessage.fromJson(json);
      case 'Retrieved':
        return RetrievedMessage.fromJson(json);
      case 'SetReply':
        return SetReplyMessage.fromJson(json);
      default:
        throw 'Invalid message command';
    }
  }
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class RoomInfoMessage extends ServerMessage {
  @override
  final String cmd = 'RoomInfo';
  final NetworkVersion version;
  final NetworkVersion generatorVersion;
  final List<String> tags;
  final bool password;
  final PermissionsDict permissions;
  final int hintCost;
  final int locationCheckPoints;
  final List<String> games;
  final Map<String, String> datapackageChecksums;
  final String seedName;
  @JsonKey(fromJson: fromPythonTimeJson, toJson: toPythonTimeJson)
  final DateTime time;
  RoomInfoMessage(
    this.version,
    this.generatorVersion,
    this.tags,
    this.password,
    this.permissions,
    this.hintCost,
    this.locationCheckPoints,
    this.games,
    this.datapackageChecksums,
    this.seedName,
    this.time,
  );

  factory RoomInfoMessage.fromJson(Map<String, dynamic> json) =>
      _$RoomInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RoomInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ConnectionRefusedMessage extends ServerMessage {
  @override
  final String cmd = "ConnectionRefused";
  final List<ConnectionRefusedReason>? errors;

  ConnectionRefusedMessage([this.errors]);

  factory ConnectionRefusedMessage.fromJson(Map<String, dynamic> json) =>
      _$ConnectionRefusedFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionRefusedToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ConnectionRefusedReason {
  invalidSlot,
  invalidGame,
  incompatibleVersion,
  invalidPassword,
  invalidItemsHandling,
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ConnectedMessage extends ServerMessage {
  @override
  final String cmd = "Connected";
  final int team;
  final int slot;
  final List<NetworkPlayer> players;
  final List<int> missingLocations;
  final List<int> checkedLocations;

  /// Slot related data, differs per game.
  /// Empty if not required, not present if slot_data in Connect is false.
  final Map<String, dynamic>? slotData;
  final Map<int, NetworkSlot> slotInfo;
  final int hintPoints;

  ConnectedMessage(
    this.team,
    this.slot,
    this.players,
    this.missingLocations,
    this.checkedLocations,
    this.slotInfo,
    this.hintPoints, [
    this.slotData,
  ]);

  factory ConnectedMessage.fromJson(Map<String, dynamic> json) =>
      _$ConnectedFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReceivedItemsMessage extends ServerMessage {
  @override
  final String cmd = "ReceivedItems";
  final int index;
  final List<NetworkItem> items;

  ReceivedItemsMessage(this.index, this.items);

  factory ReceivedItemsMessage.fromJson(Map<String, dynamic> json) =>
      _$ReceivedItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivedItemsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LocationInfoMessage extends ServerMessage {
  @override
  final String cmd = "LocationInfo";
  final List<NetworkItem> locations;

  LocationInfoMessage(this.locations);

  factory LocationInfoMessage.fromJson(Map<String, dynamic> json) =>
      _$LocationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class RoomUpdateMessage extends ServerMessage {
  @override
  final String cmd = "RoomUpdate";
  final List<NetworkPlayer>? players;
  final List<int>? checkedLocations;

  // RoomInfo fields.
  // Not included: version, generator_version.
  // generator_version would only change with a new world, and hence, a new room.
  // version would only change with a server update, which shouldn't happen during a connection.
  final List<String>? tags;
  final bool? password;
  final PermissionsDict? permissions;
  final int? hintCost;
  final int? locationCheckPoints;
  final List<String>? games;
  final Map<String, String>? datapackageChecksums;
  final String? seedName;
  @JsonKey(
    fromJson: nullableFromPythonTimeJson,
    toJson: nullableToPythonTimeJson,
  )
  final DateTime? time;

  // Connected fields.
  // Not included: players, checked_locations, missing_locations.
  // players and checked_locations are special cases, handled as diffs above.
  // missing_locations should never be sent in this message.
  final int? team;
  final int? slot;
  final Map<String, dynamic>? slotData;
  final Map<int, NetworkSlot>? slotInfo;
  final int? hintPoints;

  RoomUpdateMessage({
    this.tags,
    this.password,
    this.permissions,
    this.hintCost,
    this.locationCheckPoints,
    this.games,
    this.datapackageChecksums,
    this.seedName,
    this.time,
    this.team,
    this.slot,
    this.slotData,
    this.slotInfo,
    this.hintPoints,
    this.players,
    this.checkedLocations,
  });

  factory RoomUpdateMessage.fromJson(Map<String, dynamic> json) =>
      _$RoomUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RoomUpdateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PrintJSONMessage extends ServerMessage {
  @override
  final String cmd = "PrintJSON";
  final List<JSONMessagePart> data;
  final PrintJSONType? type;
  final int? receiving;
  final NetworkItem? item;
  final bool? found;
  final int? team;
  final int? slot;
  final String? message;
  final List<String>? tags;
  final int? countdown;

  PrintJSONMessage(
    this.data, {
    this.type,
    this.receiving,
    this.item,
    this.found,
    this.team,
    this.slot,
    this.message,
    this.tags,
    this.countdown,
  });

  factory PrintJSONMessage.fromJson(Map<String, dynamic> json) =>
      _$PrintJSONFromJson(json);

  Map<String, dynamic> toJson() => _$PrintJSONToJson(this);
}

@JsonEnum(valueField: 'text')
enum PrintJSONType {
  itemsend("ItemSend"),
  itemcheat("ItemCheat"),
  hint("Hint"),
  join("Join"),
  part("Part"),
  chat("Chat"),
  serverChat("ServerChat"),
  tutorial("Tutorial"),
  tagsChanged("TagsChanged"),
  commandResult("CommandResult"),
  adminCommandResult("AdminCommandResult"),
  goal("Goal"),
  release("Release"),
  collect("Collect"),
  countdown("Countdown");

  final String text;
  const PrintJSONType(this.text);
}

@JsonSerializable(explicitToJson: true)
class DataPackageMessage extends ServerMessage {
  @override
  final String cmd = "DataPackage";
  final DataPackageContents data;

  DataPackageMessage(this.data);

  factory DataPackageMessage.fromJson(Map<String, dynamic> json) =>
      _$DataPackageFromJson(json);

  Map<String, dynamic> toJson() => _$DataPackageToJson(this);
}

@JsonSerializable()
class BouncedMessage extends ServerMessage {
  @override
  final String cmd = "Bounced";
  final List<String>? games;
  final List<int>? slots;
  final List<String>? tags;
  final Map<dynamic, dynamic> data;

  BouncedMessage(this.data, {this.games, this.slots, this.tags});

  factory BouncedMessage.fromJson(Map<String, dynamic> json) =>
      _$BouncedFromJson(json);

  Map<String, dynamic> toJson() => _$BouncedToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class InvalidPacketMessage extends ServerMessage {
  @override
  final String cmd = "InvalidPacket";
  final PacketProblemType type;
  final String? originalCommand;
  final String text;

  InvalidPacketMessage(this.type, this.originalCommand, this.text);

  factory InvalidPacketMessage.fromJson(Map<String, dynamic> json) =>
      _$InvalidPacketFromJson(json);

  Map<String, dynamic> toJson() => _$InvalidPacketToJson(this);
}

@JsonEnum()
enum PacketProblemType { cmd, arguments }

@JsonSerializable()
class RetrievedMessage extends ServerMessage {
  @override
  final String cmd = "Retrieved";
  final Map<String, dynamic> keys;

  RetrievedMessage(this.keys);

  factory RetrievedMessage.fromJson(Map<String, dynamic> json) =>
      _$RetrievedFromJson(json);

  Map<String, dynamic> toJson() => _$RetrievedToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SetReplyMessage extends ServerMessage {
  @override
  final String cmd = "SetReply";
  final String key;
  final dynamic value;
  final dynamic originalValue;
  final int slot;

  SetReplyMessage(this.key, this.value, this.originalValue, this.slot);

  factory SetReplyMessage.fromJson(Map<String, dynamic> json) =>
      _$SetReplyFromJson(json);

  Map<String, dynamic> toJson() => _$SetReplyToJson(this);
}
