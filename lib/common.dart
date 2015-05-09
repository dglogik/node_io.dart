library node_io.common;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:js';

// JsObject _dns = require('dns');

abstract class InternetAddress {

  List<int> get rawAddress;
  InternetAddressType type;

  String get address;
  String get host;

  bool get isLinkLocal;
  bool get isLoopback;
  bool get isMulticast;

  InternetAddress(String address);

  static Future<List<InternetAddress>> lookup(String host, {InternetAddressType type: InternetAddressType.ANY});

  Future<InternetAddress> reverse();
}

abstract class IOSink implements StringSink, StreamSink<List<int>> {

  Encoding encoding;
  Future get done;

  IOSink(StreamConsumer<List<int>> target, {this.encoding: UTF8});

  void add(List<int> data);

  void addError(error, [StackTrace stackTrace]);

  Future addStream(Stream<List<int>> stream);

  Future close();

  Future flush();

  void write(Object obj);

  void writeAll(Iterable objects, [String separator=""]);

  void writeCharCode(int charCode);

  void writeln([Object obj=""]);
}

abstract class Socket implements IOSink, Stream<List<int>> {
  Encoding encoding;

  InternetAddress get address;
  InternetAddress get remoteAddress;

  int get port;
  int get remotePort;

  static Future<Socket> connect(host, int port, {sourceAddress}) {
    return null;
  }

  void destroy();
  bool setOption(SocketOption option, bool enabled);
}

class InternetAddressType {
  static const InternetAddressType IP_V4 = const InternetAddressType._("IP_v4");
  static const InternetAddressType IP_V6 = const InternetAddressType._("IP_v6");
  static const InternetAddressType ANY = const InternetAddressType._("ANY");

  final String name;

  const InternetAddressType._(this.name);

  String toString() => "InternetAddressType: $name";
}

class X509Certificate {
  final String subject;
  final String issuer;

  final DateTime startValidity;
  final DateTime endValidity;

  X509Certificate(this.subject, this.issuer, this.startValidity, this.endValidity);
}