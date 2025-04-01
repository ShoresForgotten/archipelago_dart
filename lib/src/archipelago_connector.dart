library;

import 'dart:async';
import 'dart:convert';

import 'client_to_server.dart';
import 'server_to_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A connection to an Archipelago server.
/// Can send and receive lists of JSON objects.

interface class ArchipelagoConnector {
  WebSocketChannel? _channel;
  final StreamController<ServerMessage> _stream = StreamController();
  Stream<ServerMessage> get stream => _stream.stream;
  bool _connected = false;
  bool get connected => _connected;
  final String host;
  final int port;

  ArchipelagoConnector(this.host, this.port);

  // TODO: Maybe change this so it uses a more user-facing type
  void send(ClientMessage message) {
    sendMultiple([message]);
  }

  void sendMultiple(List<ClientMessage> messages) {
    _channel?.sink.add(jsonEncode(messages));
  }

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri(host: host, port: port, scheme: 'ws'),
      );
      await _channel!.ready;
    } catch (e) {
      _channel = WebSocketChannel.connect(
        Uri(host: host, port: port, scheme: 'wss'),
      );
      await _channel!.ready;
    }
    _connected = true;
    _stream
        .addStream(
          _channel!.stream
              .map((event) => jsonDecode(event) as List<dynamic>)
              .expand((x) => x)
              .map((x) => ServerMessage.fromJson(x)),
        )
        .then((_) {
          _channel = null;
          _connected = false;
        });
  }

  Future<void> disconnect() {
    //TODO: Add disconnect
    throw UnimplementedError();
  }
}
