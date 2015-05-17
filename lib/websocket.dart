library node_io.websocket;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:js';

part 'src/websocket/socket.dart';

JsObject _ws = require(Uri.base.toFilePath() + "/node_modules/ws");

class WebSocketException implements Exception {
  final String message;

  WebSocketException(this.message);

  String toString() {
    return "WebSocketException: $message";
  }
}
