library node_io.websocket;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:js';

part 'src/websocket/socket.dart';

JsObject _ws = require("ws");
