// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkPlayer _$NetworkPlayerFromJson(Map<String, dynamic> json) =>
    NetworkPlayer(
      (json['team'] as num).toInt(),
      (json['slot'] as num).toInt(),
      json['alias'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$NetworkPlayerToJson(NetworkPlayer instance) =>
    <String, dynamic>{
      'class': instance.classKey,
      'team': instance.team,
      'slot': instance.slot,
      'alias': instance.alias,
      'name': instance.name,
    };

NetworkItem _$NetworkItemFromJson(Map<String, dynamic> json) => NetworkItem(
  (json['item'] as num).toInt(),
  (json['location'] as num).toInt(),
  (json['player'] as num).toInt(),
  NetworkItemFlags.fromJson((json['flags'] as num).toInt()),
);

Map<String, dynamic> _$NetworkItemToJson(NetworkItem instance) =>
    <String, dynamic>{
      'class': instance.classKey,
      'item': instance.item,
      'location': instance.location,
      'player': instance.player,
      'flags': instance.flags.toJson(),
    };

TextJSONMessagePart _$TextJSONMessagePartFromJson(Map<String, dynamic> json) =>
    TextJSONMessagePart(json['text'] as String);

Map<String, dynamic> _$TextJSONMessagePartToJson(
  TextJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text};

PlayerIDJSONMessagePart _$PlayerIDJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => PlayerIDJSONMessagePart(json['text'] as String);

Map<String, dynamic> _$PlayerIDJSONMessagePartToJson(
  PlayerIDJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text};

PlayerNameJSONMessagePart _$PlayerNameJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => PlayerNameJSONMessagePart(json['text'] as String);

Map<String, dynamic> _$PlayerNameJSONMessagePartToJson(
  PlayerNameJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text};

ItemIDJSONMessagePart _$ItemIDJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => ItemIDJSONMessagePart(
  json['text'] as String,
  NetworkItemFlags.fromJson((json['flags'] as num).toInt()),
  (json['player'] as num).toInt(),
);

Map<String, dynamic> _$ItemIDJSONMessagePartToJson(
  ItemIDJSONMessagePart instance,
) => <String, dynamic>{
  'text': instance.text,
  'flags': instance.flags.toJson(),
  'player': instance.player,
};

ItemNameJSONMessagePart _$ItemNameJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => ItemNameJSONMessagePart(
  json['text'] as String,
  NetworkItemFlags.fromJson((json['flags'] as num).toInt()),
  (json['player'] as num).toInt(),
);

Map<String, dynamic> _$ItemNameJSONMessagePartToJson(
  ItemNameJSONMessagePart instance,
) => <String, dynamic>{
  'text': instance.text,
  'flags': instance.flags.toJson(),
  'player': instance.player,
};

LocationIDJSONMessagePart _$LocationIDJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => LocationIDJSONMessagePart(
  json['text'] as String,
  (json['player'] as num).toInt(),
);

Map<String, dynamic> _$LocationIDJSONMessagePartToJson(
  LocationIDJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text, 'player': instance.player};

LocationNameJSONMessagePart _$LocationNameJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => LocationNameJSONMessagePart(
  json['text'] as String,
  (json['player'] as num).toInt(),
);

Map<String, dynamic> _$LocationNameJSONMessagePartToJson(
  LocationNameJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text, 'player': instance.player};

EntranceNameJSONMessagePart _$EntranceNameJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => EntranceNameJSONMessagePart(json['text'] as String);

Map<String, dynamic> _$EntranceNameJSONMessagePartToJson(
  EntranceNameJSONMessagePart instance,
) => <String, dynamic>{'text': instance.text};

HintStatusJSONMessagePart _$HintStatusJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => HintStatusJSONMessagePart(
  json['text'] as String,
  $enumDecode(_$HintStatusEnumMap, json['status']),
);

Map<String, dynamic> _$HintStatusJSONMessagePartToJson(
  HintStatusJSONMessagePart instance,
) => <String, dynamic>{
  'text': instance.text,
  'status': _$HintStatusEnumMap[instance.status]!,
};

const _$HintStatusEnumMap = {
  HintStatus.unspecified: 0,
  HintStatus.noPriority: 10,
  HintStatus.avoid: 20,
  HintStatus.priority: 30,
  HintStatus.found: 40,
};

ColorJSONMessagePart _$ColorJSONMessagePartFromJson(
  Map<String, dynamic> json,
) => ColorJSONMessagePart(
  json['text'] as String,
  $enumDecode(_$ConsoleColorEnumMap, json['color']),
);

Map<String, dynamic> _$ColorJSONMessagePartToJson(
  ColorJSONMessagePart instance,
) => <String, dynamic>{
  'text': instance.text,
  'color': _$ConsoleColorEnumMap[instance.color]!,
};

const _$ConsoleColorEnumMap = {
  ConsoleColor.bold: 'bold',
  ConsoleColor.underline: 'underline',
  ConsoleColor.black: 'black',
  ConsoleColor.red: 'red',
  ConsoleColor.green: 'green',
  ConsoleColor.yellow: 'yellow',
  ConsoleColor.blue: 'blue',
  ConsoleColor.magenta: 'magenta',
  ConsoleColor.cyan: 'cyan',
  ConsoleColor.white: 'white',
  ConsoleColor.blackBackground: 'black_bg',
  ConsoleColor.redBackground: 'red_bg',
  ConsoleColor.greenBackground: 'green_bg',
  ConsoleColor.yellowBackground: 'yellow_bg',
  ConsoleColor.blueBackground: 'blue_bg',
  ConsoleColor.magentaBackground: 'magenta_bg',
  ConsoleColor.cyanBackground: 'cyan_bg',
  ConsoleColor.whiteBackground: 'white_bg',
};

NetworkVersion _$NetworkVersionFromJson(Map<String, dynamic> json) =>
    NetworkVersion(
      (json['major'] as num).toInt(),
      (json['minor'] as num).toInt(),
      (json['build'] as num).toInt(),
    );

Map<String, dynamic> _$NetworkVersionToJson(NetworkVersion instance) =>
    <String, dynamic>{
      'class': instance.classKey,
      'major': instance.major,
      'minor': instance.minor,
      'build': instance.build,
    };

NetworkSlot _$NetworkSlotFromJson(Map<String, dynamic> json) => NetworkSlot(
  json['name'] as String,
  json['game'] as String,
  SlotType.fromJson((json['type'] as num).toInt()),
  (json['groupMembers'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$NetworkSlotToJson(NetworkSlot instance) =>
    <String, dynamic>{
      'class': instance.classKey,
      'name': instance.name,
      'game': instance.game,
      'type': instance.type.toJson(),
      'groupMembers': instance.groupMembers,
    };

PermissionsDict _$PermissionsDictFromJson(Map<String, dynamic> json) =>
    PermissionsDict(
      $enumDecode(_$PermissionEnumMap, json['release']),
      $enumDecode(_$PermissionEnumMap, json['collect']),
      $enumDecode(_$PermissionEnumMap, json['remaining']),
    );

Map<String, dynamic> _$PermissionsDictToJson(PermissionsDict instance) =>
    <String, dynamic>{
      'release': _$PermissionEnumMap[instance.release]!,
      'collect': _$PermissionEnumMap[instance.collect]!,
      'remaining': _$PermissionEnumMap[instance.remaining]!,
    };

const _$PermissionEnumMap = {
  Permission.disabled: 0,
  Permission.enabled: 1,
  Permission.goal: 2,
  Permission.auto: 6,
  Permission.autoEnabled: 7,
};

Hint _$HintFromJson(Map<String, dynamic> json) => Hint(
  (json['receivingPlayer'] as num).toInt(),
  (json['findingPlayer'] as num).toInt(),
  (json['location'] as num).toInt(),
  (json['item'] as num).toInt(),
  json['found'] as bool,
  entrance: json['entrance'] as String? ?? "",
  flags:
      json['flags'] == null
          ? NetworkItemFlags.emptyFlags
          : NetworkItemFlags.fromJson((json['flags'] as num).toInt()),
  status:
      $enumDecodeNullable(_$HintStatusEnumMap, json['status']) ??
      HintStatus.unspecified,
);

Map<String, dynamic> _$HintToJson(Hint instance) => <String, dynamic>{
  'class': instance.classKey,
  'receivingPlayer': instance.receivingPlayer,
  'findingPlayer': instance.findingPlayer,
  'location': instance.location,
  'item': instance.item,
  'found': instance.found,
  'entrance': instance.entrance,
  'flags': instance.flags.toJson(),
  'status': _$HintStatusEnumMap[instance.status]!,
};

DataPackageContents _$DataPackageContentsFromJson(Map<String, dynamic> json) =>
    DataPackageContents(
      (json['games'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, GameData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$DataPackageContentsToJson(
  DataPackageContents instance,
) => <String, dynamic>{
  'games': instance.games.map((k, e) => MapEntry(k, e.toJson())),
};

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
  Map<String, int>.from(json['item_name_to_id'] as Map),
  Map<String, int>.from(json['location_name_to_id'] as Map),
  json['checksum'] as String,
);

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
  'item_name_to_id': instance.itemNameToId,
  'location_name_to_id': instance.locationNameToId,
  'checksum': instance.checksum,
};

DeathLink _$DeathLinkFromJson(Map<String, dynamic> json) => DeathLink(
  fromPythonTimeJson((json['time'] as num).toDouble()),
  json['source'] as String,
  json['cause'] as String?,
);

Map<String, dynamic> _$DeathLinkToJson(DeathLink instance) => <String, dynamic>{
  'time': toPythonTimeJson(instance.time),
  'cause': instance.cause,
  'source': instance.source,
};
