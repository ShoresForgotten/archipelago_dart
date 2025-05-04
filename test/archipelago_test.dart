import 'dart:async';

import 'package:archipelago/src/archipelago_connector.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:stream_channel/stream_channel.dart';

import 'package:archipelago/archipelago.dart';
import 'package:archipelago/src/protocol_types/client_to_server.dart' as client;
import 'package:archipelago/src/protocol_types/server_to_client.dart' as server;
import 'package:archipelago/src/protocol_types/general_types.dart';

@GenerateNiceMocks([
  MockSpec<StreamChannel>(),
  MockSpec<StreamSink>(),
  MockSpec<ArchipelagoProtocolConnector>(),
  MockSpec<ArchipelagoProtocolConnection>(),
])
import 'archipelago_test.mocks.dart';

typedef JSON = Map<String, dynamic>;

void main() {
  group('Client API', () {
    group('Connecting to server', () {
      test('Handshake requesting no DataPackages', () async {
        final MockArchipelagoProtocolConnector mockConnector =
            MockArchipelagoProtocolConnector();
        final MockArchipelagoProtocolConnection mockConnection =
            MockArchipelagoProtocolConnection();
        final NetworkVersion networkVersion = NetworkVersion(0, 6, 0);

        when(
          mockConnector.connect(),
        ).thenAnswer((_) => Future.value(mockConnection));

        when(mockConnection.stream).thenAnswer(
          (_) => Stream.fromIterable([
            server.RoomInfoMessage(
              networkVersion,
              networkVersion,
              [],
              false,
              PermissionsDict(
                Permission.auto,
                Permission.auto,
                Permission.auto,
              ),
              5,
              1,
              [],
              {},
              'potato',
              DateTime.now(),
            ),
            server.ConnectedMessage(
              0,
              1,
              [NetworkPlayer(0, 1, 'Bob Hamelin', 'Bob')],
              [],
              [],
              {1: NetworkSlot('Bob', 'Spacewar', SlotType(true, false), [])},
              0,
            ),
          ]),
        );
        final uuid = 'test';

        final archipelagoClient = await ArchipelagoClient.connectWithConnector(
          name: 'Bob Hamelin',
          uuid: uuid,
          game: 'Spacewar',
          receiveOtherWorlds: true,
          connector: mockConnector,
        );

        expect(
          verify(mockConnection.send(captureAny)).captured.single,
          client.ConnectMessage(
            null,
            'Spacewar',
            'Bob Hamelin',
            uuid,
            networkVersion,
            true,
            false,
            false,
            [],
            false,
          ),
        );
      });
      test('Handshake requesting a DataPackage', () async {
        final MockArchipelagoProtocolConnector mockConnector =
            MockArchipelagoProtocolConnector();
        final MockArchipelagoProtocolConnection mockConnection =
            MockArchipelagoProtocolConnection();
        final NetworkVersion networkVersion = NetworkVersion(0, 6, 0);

        when(
          mockConnector.connect(),
        ).thenAnswer((_) => Future.value(mockConnection));

        when(mockConnection.stream).thenAnswer(
          (_) => Stream.fromIterable([
            server.RoomInfoMessage(
              networkVersion,
              networkVersion,
              [],
              false,
              PermissionsDict(
                Permission.auto,
                Permission.auto,
                Permission.auto,
              ),
              5,
              1,
              ['Spacewar'],
              {'Spacewar': 'loremipsum'},
              'potato',
              DateTime.now(),
            ),
            server.DataPackageMessage(
              DataPackageContents({'Spacewar': GameData({}, {}, 'loremipsum')}),
            ),
            server.ConnectedMessage(
              0,
              1,
              [NetworkPlayer(0, 1, 'Bob Hamelin', 'Bob')],
              [],
              [],
              {1: NetworkSlot('Bob', 'Spacewar', SlotType(true, false), [])},
              0,
            ),
          ]),
        );
        final uuid = 'test';

        final archipelagoClient = await ArchipelagoClient.connectWithConnector(
          name: 'Bob Hamelin',
          uuid: uuid,
          game: 'Spacewar',
          receiveOtherWorlds: true,
          connector: mockConnector,
        );

        expect(verify(mockConnection.send(captureAny)).captured, [
          client.GetDataPackageMessage(['Spacewar']),
          client.ConnectMessage(
            null,
            'Spacewar',
            'Bob Hamelin',
            uuid,
            networkVersion,
            true,
            false,
            false,
            [],
            false,
          ),
        ]);
      });
    });
  });
  group('Miscellaneous types', () {
    group('Item flags', () {
      test('Serialization', () {
        for (var i = 0; i < 8; i++) {
          var obj = NetworkItemFlags(
            logicalAdvancement: i % 2 == 1,
            useful: i % 4 >= 2,
            trap: i > 3,
          );
          expect(obj.toJson(), i);
        }
      });
      test('Deserialization', () {
        for (var i = 0; i < 8; i++) {
          var json = NetworkItemFlags.fromJson(i);
          expect(
            json.logicalAdvancement,
            i % 2 == 1,
            reason: 'Logical advancement',
          );
          expect(json.useful, i % 4 >= 2, reason: 'Useful');
          expect(json.trap, i > 3, reason: 'Trap');
        }
      });
    });
    group('JSON message part deserialization', () {
      test('Text', () {
        final JSON json = {'type': 'text', 'text': 'Lorem ipsum'};
        expect(JSONMessagePart.fromJson(json).runtimeType, TextJSONMessagePart);
      });
      test('Player ID', () {
        final JSON json = {'type': 'player_id', 'text': '1'};
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          PlayerIDJSONMessagePart,
        );
      });
      test('Player name', () {
        final JSON json = {'type': 'player_name', 'text': 'Bob'};
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          PlayerNameJSONMessagePart,
        );
      });
      test('Item ID', () {
        final JSON json = {
          'type': 'item_id',
          'text': '1',
          'flags': 7,
          'player': 1,
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          ItemIDJSONMessagePart,
        );
      });
      test('Item name', () {
        final JSON json = {
          'type': 'item_name',
          'text': 'Sword',
          'flags': 7,
          'player': 1,
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          ItemNameJSONMessagePart,
        );
      });
      test('Location ID', () {
        final JSON json = {'type': 'location_id', 'text': '1', 'player': 1};
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          LocationIDJSONMessagePart,
        );
      });
      test('Location name', () {
        final JSON json = {
          'type': 'location_name',
          'text': 'Bielefeld',
          'player': 1,
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          LocationNameJSONMessagePart,
        );
      });
      test('Entrance name', () {
        final JSON json = {
          'type': 'entrance_name',
          'text': 'Bielefeld city limit',
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          EntranceNameJSONMessagePart,
        );
      });
      test('Hint status', () {
        final JSON json = {
          'type': 'hint_status',
          'text': 'Sword',
          'status': 30,
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          HintStatusJSONMessagePart,
        );
      });
      test('Color', () {
        final JSON json = {
          'type': 'color',
          'text': 'Lorem ipsum',
          'color': 'magenta',
        };
        expect(
          JSONMessagePart.fromJson(json).runtimeType,
          ColorJSONMessagePart,
        );
      });
    });
    test('Slot type deserialization', () {
      for (var i = 0; i < 4; i++) {
        final obj = SlotType.fromJson(i);
        expect(obj.player, i % 2 == 1);
        expect(obj.group, i > 1);
      }
    });
  });

  //TODO: Write more tests
}
