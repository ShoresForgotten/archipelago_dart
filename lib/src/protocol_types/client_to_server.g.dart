// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_to_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectMessage _$ConnectMessageFromJson(Map<String, dynamic> json) =>
    ConnectMessage._jsonConstructor(
      json['password'] as String?,
      json['game'] as String?,
      json['name'] as String,
      json['uuid'] as String,
      NetworkVersion.fromJson(json['version'] as Map<String, dynamic>),
      json['items_handling'] == null
          ? null
          : _ItemsHandlingFlags.fromJson(
            (json['items_handling'] as num).toInt(),
          ),
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      json['slot_data'] as bool,
    );

Map<String, dynamic> _$ConnectMessageToJson(ConnectMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'password': instance.password,
      'game': instance.game,
      'name': instance.name,
      'uuid': instance.uuid,
      'version': instance.version.toJson(),
      'items_handling': instance.itemsHandling?.toJson(),
      'tags': instance.tags,
      'slot_data': instance.slotData,
    };

ConnectUpdateMessage _$ConnectUpdateMessageFromJson(
  Map<String, dynamic> json,
) => ConnectUpdateMessage(
  json['receive_other_worlds'] as bool,
  json['receive_own_world'] as bool,
  json['receive_starting_inventory'] as bool,
  (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ConnectUpdateMessageToJson(
  ConnectUpdateMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'receive_other_worlds': instance.receiveOtherWorlds,
  'receive_own_world': instance.receiveOwnWorld,
  'receive_starting_inventory': instance.receiveStartingInventory,
  'tags': instance.tags,
};

SyncMessage _$SyncMessageFromJson(Map<String, dynamic> json) => SyncMessage();

Map<String, dynamic> _$SyncMessageToJson(SyncMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd};

LocationChecksMessage _$LocationChecksMessageFromJson(
  Map<String, dynamic> json,
) => LocationChecksMessage(
  (json['locations'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
);

Map<String, dynamic> _$LocationChecksMessageToJson(
  LocationChecksMessage instance,
) => <String, dynamic>{'cmd': instance.cmd, 'locations': instance.locations};

LocationScoutsMessage _$LocationScoutsMessageFromJson(
  Map<String, dynamic> json,
) => LocationScoutsMessage(
  (json['locations'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  (json['create_as_hint'] as num).toInt(),
);

Map<String, dynamic> _$LocationScoutsMessageToJson(
  LocationScoutsMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'locations': instance.locations,
  'create_as_hint': instance.createAsHint,
};

UpdateHintMessage _$UpdateHintMessageFromJson(Map<String, dynamic> json) =>
    UpdateHintMessage(
      (json['player'] as num).toInt(),
      (json['location'] as num).toInt(),
      $enumDecodeNullable(_$HintStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UpdateHintMessageToJson(UpdateHintMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'player': instance.player,
      'location': instance.location,
      'status': _$HintStatusEnumMap[instance.status],
    };

const _$HintStatusEnumMap = {
  HintStatus.unspecified: 0,
  HintStatus.noPriority: 10,
  HintStatus.avoid: 20,
  HintStatus.priority: 30,
  HintStatus.found: 40,
};

StatusUpdateMessage _$StatusUpdateMessageFromJson(Map<String, dynamic> json) =>
    StatusUpdateMessage($enumDecode(_$ClientStatusEnumMap, json['status']));

Map<String, dynamic> _$StatusUpdateMessageToJson(
  StatusUpdateMessage instance,
) => <String, dynamic>{
  'cmd': instance.cmd,
  'status': _$ClientStatusEnumMap[instance.status]!,
};

const _$ClientStatusEnumMap = {
  ClientStatus.unknown: 0,
  ClientStatus.connected: 5,
  ClientStatus.ready: 10,
  ClientStatus.playing: 20,
  ClientStatus.goal: 30,
};

SayMessage _$SayMessageFromJson(Map<String, dynamic> json) =>
    SayMessage(json['text'] as String);

Map<String, dynamic> _$SayMessageToJson(SayMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'text': instance.text};

GetDataPackageMessage _$GetDataPackageMessageFromJson(
  Map<String, dynamic> json,
) => GetDataPackageMessage(
  (json['games'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$GetDataPackageMessageToJson(
  GetDataPackageMessage instance,
) => <String, dynamic>{'cmd': instance.cmd, 'games': instance.games};

BounceMessage _$BounceMessageFromJson(Map<String, dynamic> json) =>
    BounceMessage(
      games:
          (json['games'] as List<dynamic>?)?.map((e) => e as String).toList(),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$BounceMessageToJson(BounceMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'games': instance.games,
      'slots': instance.slots,
      'tags': instance.tags,
      'data': instance.data,
    };

GetMessage _$GetMessageFromJson(Map<String, dynamic> json) => GetMessage(
  (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$GetMessageToJson(GetMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'keys': instance.keys};

Map<String, dynamic> _$SetMessageToJson(SetMessage instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'key': instance.key,
      'default': instance.defaultValue,
      'want_reply': instance.wantReply,
      'operations': instance.operations.map((e) => e.toJson()).toList(),
      'hash_code': instance.hashCode,
    };

NumericStorageOperation _$NumericStorageOperationFromJson(
  Map<String, dynamic> json,
) => NumericStorageOperation(
  $enumDecode(_$NumericStorageOperationTypeEnumMap, json['operation']),
  json['value'] as num,
);

Map<String, dynamic> _$NumericStorageOperationToJson(
  NumericStorageOperation instance,
) => <String, dynamic>{
  'operation': _$NumericStorageOperationTypeEnumMap[instance.operation]!,
  'value': instance.value,
};

const _$NumericStorageOperationTypeEnumMap = {
  NumericStorageOperationType.mul: 'mul',
  NumericStorageOperationType.pow: 'pow',
  NumericStorageOperationType.mod: 'mod',
  NumericStorageOperationType.floor: 'floor',
  NumericStorageOperationType.ceil: 'ceil',
  NumericStorageOperationType.max: 'max',
  NumericStorageOperationType.min: 'min',
};

BitwiseStorageOperation _$BitwiseStorageOperationFromJson(
  Map<String, dynamic> json,
) => BitwiseStorageOperation(
  $enumDecode(_$BitwiseStorageOperationTypeEnumMap, json['operation']),
  (json['value'] as num).toInt(),
);

Map<String, dynamic> _$BitwiseStorageOperationToJson(
  BitwiseStorageOperation instance,
) => <String, dynamic>{
  'operation': _$BitwiseStorageOperationTypeEnumMap[instance.operation]!,
  'value': instance.value,
};

const _$BitwiseStorageOperationTypeEnumMap = {
  BitwiseStorageOperationType.xor: 'xor',
  BitwiseStorageOperationType.or: 'or',
  BitwiseStorageOperationType.and: 'and',
  BitwiseStorageOperationType.leftShift: 'left_shift',
  BitwiseStorageOperationType.rightShift: 'right_shift',
};

ArrayAddStorageOperation _$ArrayAddStorageOperationFromJson(
  Map<String, dynamic> json,
) => ArrayAddStorageOperation(json['value'] as List<dynamic>);

Map<String, dynamic> _$ArrayAddStorageOperationToJson(
  ArrayAddStorageOperation instance,
) => <String, dynamic>{'value': instance.value};

DefaultStorageOperation _$DefaultStorageOperationFromJson(
  Map<String, dynamic> json,
) => DefaultStorageOperation();

Map<String, dynamic> _$DefaultStorageOperationToJson(
  DefaultStorageOperation instance,
) => <String, dynamic>{};

DynamicStorageOperation _$DynamicStorageOperationFromJson(
  Map<String, dynamic> json,
) => DynamicStorageOperation(
  $enumDecode(_$DynamicStorageOperationTypeEnumMap, json['operation']),
  json['value'],
);

Map<String, dynamic> _$DynamicStorageOperationToJson(
  DynamicStorageOperation instance,
) => <String, dynamic>{
  'operation': _$DynamicStorageOperationTypeEnumMap[instance.operation]!,
  'value': instance.value,
};

const _$DynamicStorageOperationTypeEnumMap = {
  DynamicStorageOperationType.replace: 'replace',
  DynamicStorageOperationType.setToDefault: 'default',
  DynamicStorageOperationType.remove: 'remove',
  DynamicStorageOperationType.pop: 'pop',
};

UpdateStorageOperation _$UpdateStorageOperationFromJson(
  Map<String, dynamic> json,
) => UpdateStorageOperation(json['value'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateStorageOperationToJson(
  UpdateStorageOperation instance,
) => <String, dynamic>{'value': instance.value};

SetNotifyMessage _$SetNotifyMessageFromJson(Map<String, dynamic> json) =>
    SetNotifyMessage(
      (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SetNotifyMessageToJson(SetNotifyMessage instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'keys': instance.keys};
