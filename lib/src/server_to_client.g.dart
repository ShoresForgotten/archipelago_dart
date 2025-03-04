// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_to_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomInfoMessage _$RoomInfoMessageFromJson(Map<String, dynamic> json) =>
    RoomInfoMessage(
      NetworkVersion.fromJson(json['version'] as Map<String, dynamic>),
      NetworkVersion.fromJson(
        json['generator_version'] as Map<String, dynamic>,
      ),
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      json['password'] as bool,
      PermissionsDict.fromJson(json['permissions'] as Map<String, dynamic>),
      (json['hint_cost'] as num).toInt(),
      (json['location_check_points'] as num).toInt(),
      (json['games'] as List<dynamic>).map((e) => e as String).toList(),
      Map<String, String>.from(json['datapackage_checksums'] as Map),
      json['seed_name'] as String,
      fromPythonTimeJson((json['time'] as num).toDouble()),
    );

Map<String, dynamic> _$RoomInfoMessageToJson(RoomInfoMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'version': instance.version.toJson(),
      'generator_version': instance.generatorVersion.toJson(),
      'tags': instance.tags,
      'password': instance.password,
      'permissions': instance.permissions.toJson(),
      'hint_cost': instance.hintCost,
      'location_check_points': instance.locationCheckPoints,
      'games': instance.games,
      'datapackage_checksums': instance.datapackageChecksums,
      'seed_name': instance.seedName,
      'time': toPythonTimeJson(instance.time),
    };

ConnectionRefusedMessage _$ConnectionRefusedMessageFromJson(
  Map<String, dynamic> json,
) => ConnectionRefusedMessage(
  (json['errors'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$ConnectionRefusedReasonEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$ConnectionRefusedMessageToJson(
  ConnectionRefusedMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'errors':
      instance.errors
          ?.map((e) => _$ConnectionRefusedReasonEnumMap[e]!)
          .toList(),
};

const _$ConnectionRefusedReasonEnumMap = {
  ConnectionRefusedReason.invalidSlot: 'InvalidSlot',
  ConnectionRefusedReason.invalidGame: 'InvalidGame',
  ConnectionRefusedReason.incompatibleVersion: 'IncompatibleVersion',
  ConnectionRefusedReason.invalidPassword: 'InvalidPassword',
  ConnectionRefusedReason.invalidItemsHandling: 'InvalidItemsHandling',
};

ConnectedMessage _$ConnectedMessageFromJson(Map<String, dynamic> json) =>
    ConnectedMessage(
      (json['team'] as num).toInt(),
      (json['slot'] as num).toInt(),
      (json['players'] as List<dynamic>)
          .map((e) => NetworkPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['missing_locations'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['checked_locations'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['slot_info'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          int.parse(k),
          NetworkSlot.fromJson(e as Map<String, dynamic>),
        ),
      ),
      (json['hint_points'] as num).toInt(),
      json['slot_data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ConnectedMessageToJson(ConnectedMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'team': instance.team,
      'slot': instance.slot,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'missing_locations': instance.missingLocations,
      'checked_locations': instance.checkedLocations,
      'slot_data': instance.slotData,
      'slot_info': instance.slotInfo.map(
        (k, e) => MapEntry(k.toString(), e.toJson()),
      ),
      'hint_points': instance.hintPoints,
    };

ReceivedItemsMessage _$ReceivedItemsMessageFromJson(
  Map<String, dynamic> json,
) => ReceivedItemsMessage(
  (json['index'] as num).toInt(),
  (json['items'] as List<dynamic>)
      .map((e) => NetworkItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReceivedItemsMessageToJson(
  ReceivedItemsMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'index': instance.index,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

LocationInfoMessage _$LocationInfoMessageFromJson(Map<String, dynamic> json) =>
    LocationInfoMessage(
      (json['locations'] as List<dynamic>)
          .map((e) => NetworkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationInfoMessageToJson(
  LocationInfoMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'locations': instance.locations.map((e) => e.toJson()).toList(),
};

RoomUpdateMessage _$RoomUpdateMessageFromJson(
  Map<String, dynamic> json,
) => RoomUpdateMessage(
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  password: json['password'] as bool?,
  permissions:
      json['permissions'] == null
          ? null
          : PermissionsDict.fromJson(
            json['permissions'] as Map<String, dynamic>,
          ),
  hintCost: (json['hint_cost'] as num?)?.toInt(),
  locationCheckPoints: (json['location_check_points'] as num?)?.toInt(),
  games: (json['games'] as List<dynamic>?)?.map((e) => e as String).toList(),
  datapackageChecksums: (json['datapackage_checksums'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
  seedName: json['seed_name'] as String?,
  time: nullableFromPythonTimeJson((json['time'] as num?)?.toDouble()),
  team: (json['team'] as num?)?.toInt(),
  slot: (json['slot'] as num?)?.toInt(),
  slotData: json['slot_data'] as Map<String, dynamic>?,
  slotInfo: (json['slot_info'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(int.parse(k), NetworkSlot.fromJson(e as Map<String, dynamic>)),
  ),
  hintPoints: (json['hint_points'] as num?)?.toInt(),
  players:
      (json['players'] as List<dynamic>?)
          ?.map((e) => NetworkPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
  checkedLocations:
      (json['checked_locations'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
);

Map<String, dynamic> _$RoomUpdateMessageToJson(RoomUpdateMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'players': instance.players?.map((e) => e.toJson()).toList(),
      'checked_locations': instance.checkedLocations,
      'tags': instance.tags,
      'password': instance.password,
      'permissions': instance.permissions?.toJson(),
      'hint_cost': instance.hintCost,
      'location_check_points': instance.locationCheckPoints,
      'games': instance.games,
      'datapackage_checksums': instance.datapackageChecksums,
      'seed_name': instance.seedName,
      'time': nullableToPythonTimeJson(instance.time),
      'team': instance.team,
      'slot': instance.slot,
      'slot_data': instance.slotData,
      'slot_info': instance.slotInfo?.map(
        (k, e) => MapEntry(k.toString(), e.toJson()),
      ),
      'hint_points': instance.hintPoints,
    };

PrintJSONMessage _$PrintJSONMessageFromJson(Map<String, dynamic> json) =>
    PrintJSONMessage(
      (json['data'] as List<dynamic>)
          .map((e) => JSONMessagePart.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecodeNullable(_$PrintJSONTypeEnumMap, json['type']),
      receiving: (json['receiving'] as num?)?.toInt(),
      item:
          json['item'] == null
              ? null
              : NetworkItem.fromJson(json['item'] as Map<String, dynamic>),
      found: json['found'] as bool?,
      team: (json['team'] as num?)?.toInt(),
      slot: (json['slot'] as num?)?.toInt(),
      message: json['message'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      countdown: (json['countdown'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PrintJSONMessageToJson(PrintJSONMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'type': _$PrintJSONTypeEnumMap[instance.type],
      'receiving': instance.receiving,
      'item': instance.item?.toJson(),
      'found': instance.found,
      'team': instance.team,
      'slot': instance.slot,
      'message': instance.message,
      'tags': instance.tags,
      'countdown': instance.countdown,
    };

const _$PrintJSONTypeEnumMap = {
  PrintJSONType.itemsend: 'ItemSend',
  PrintJSONType.itemcheat: 'ItemCheat',
  PrintJSONType.hint: 'Hint',
  PrintJSONType.join: 'Join',
  PrintJSONType.part: 'Part',
  PrintJSONType.chat: 'Chat',
  PrintJSONType.serverChat: 'ServerChat',
  PrintJSONType.tutorial: 'Tutorial',
  PrintJSONType.tagsChanged: 'TagsChanged',
  PrintJSONType.commandResult: 'CommandResult',
  PrintJSONType.adminCommandResult: 'AdminCommandResult',
  PrintJSONType.goal: 'Goal',
  PrintJSONType.release: 'Release',
  PrintJSONType.collect: 'Collect',
  PrintJSONType.countdown: 'Countdown',
};

DataPackageMessage _$DataPackageMessageFromJson(Map<String, dynamic> json) =>
    DataPackageMessage(
      DataPackageContents.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataPackageMessageToJson(DataPackageMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'data': instance.data.toJson()};

BouncedMessage _$BouncedMessageFromJson(Map<String, dynamic> json) =>
    BouncedMessage(
      json['data'] as Map<String, dynamic>?,
      games:
          (json['games'] as List<dynamic>?)?.map((e) => e as String).toList(),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BouncedMessageToJson(BouncedMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'games': instance.games,
      'slots': instance.slots,
      'tags': instance.tags,
      'data': instance.data,
    };

InvalidPacketMessage _$InvalidPacketMessageFromJson(
  Map<String, dynamic> json,
) => InvalidPacketMessage(
  $enumDecode(_$PacketProblemTypeEnumMap, json['type']),
  json['original_command'] as String?,
  json['text'] as String,
);

Map<String, dynamic> _$InvalidPacketMessageToJson(
  InvalidPacketMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'type': _$PacketProblemTypeEnumMap[instance.type]!,
  'original_command': instance.originalCommand,
  'text': instance.text,
};

const _$PacketProblemTypeEnumMap = {
  PacketProblemType.cmd: 'cmd',
  PacketProblemType.arguments: 'arguments',
};

RetrievedMessage _$RetrievedMessageFromJson(Map<String, dynamic> json) =>
    RetrievedMessage(json['keys'] as Map<String, dynamic>);

Map<String, dynamic> _$RetrievedMessageToJson(RetrievedMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'keys': instance.keys};

SetReplyMessage _$SetReplyMessageFromJson(Map<String, dynamic> json) =>
    SetReplyMessage(
      json['key'] as String,
      json['value'],
      json['original_value'],
      (json['slot'] as num).toInt(),
    );

Map<String, dynamic> _$SetReplyMessageToJson(SetReplyMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'key': instance.key,
      'value': instance.value,
      'original_value': instance.originalValue,
      'slot': instance.slot,
    };
