library;

import 'dart:async';
import 'dart:convert';

import 'protocol_types/client_to_server.dart';
import 'protocol_types/server_to_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A factory for creating connections to Archipelago servers
interface class ArchipelagoProtocolConnector {
  final String _host;
  final int _port;
  ArchipelagoProtocolConnector(this._host, this._port);

  Future<ArchipelagoProtocolConnection> connect() async {
    WebSocketChannel channel;
    try {
      channel = WebSocketChannel.connect(
        Uri(host: _host, port: _port, scheme: 'ws'),
      );
      await channel.ready;
    } catch (e) {
      channel = WebSocketChannel.connect(
        Uri(host: _host, port: _port, scheme: 'wss'),
      );
      await channel.ready;
    }
    return ArchipelagoProtocolConnection._(channel);
  }
}

/// A connection to an Archipelago server.
/// Can send and receive lists of JSON objects.
interface class ArchipelagoProtocolConnection {
  final WebSocketChannel _channel;
  final StreamController<ServerMessage> _stream = StreamController();
  Stream<ServerMessage> get stream => _stream.stream;
  bool _connected = false;
  bool get connected => _connected;

  ArchipelagoProtocolConnection._(this._channel) {
    _stream
        .addStream(
          _channel.stream
              .map((event) => jsonDecode(event) as List<dynamic>)
              .expand((x) => x)
              .map((x) => ServerMessage.fromJson(x)),
        )
        .then((_) {
          _connected = false;
        });
  }

  // TODO: Maybe change this so it uses a more user-facing type
  void send(ClientMessage message) {
    sendMultiple([message]);
  }

  void sendMultiple(List<ClientMessage> messages) {
    _channel.sink.add(jsonEncode(messages));
  }
}
