library node_io.common;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:js';

part 'src/platform.dart';

JsObject _dns = require('dns');

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

  void writeAll(Iterable objects, [String separator = ""]);

  void writeCharCode(int charCode);

  void writeln([Object obj = ""]);
}

abstract class SocketOption {
  // TODO
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

abstract class InternetAddress {
  List<int> get rawAddress;
  InternetAddressType type;

  String get address;
  String get host;

  bool get isLinkLocal;
  bool get isLoopback;
  bool get isMulticast;

  /*
  factory InternetAddress(String address) {
    return new _InternetAddress(address);
  }
  */

  static Future<List<InternetAddress>> lookup(String host,
      {InternetAddressType type: InternetAddressType.ANY}) {
    var completer = new Completer<List<InternetAddress>>();
    var args = [host];
    if (type == InternetAddressType.IP_V4) args.add(4);
    if (type == InternetAddressType.IP_V6) args.add(6);
    args.add((err, address, family) {
      // completer.complete(<InternetAddress>[]..add(new _InternetAddress(address)));
    });

    _dns.callMethod("lookup", args);
    return completer.future;
  }

  Future<InternetAddress> reverse();
}

/*
class _InternetAddress implements InternetAddress {

  final String address;

  String get host {
  }

  List<int> get rawAddress {

  }

  InternetAddressType type() {

  }

  bool get isLinkLocal {

  }

  bool get isLoopback {

  }

  bool get isMulticast {

  }

  _InternetAddress(this.address);

  Future<InternetAddress> reverse() {

  }
}
*/

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

  X509Certificate(
      this.subject, this.issuer, this.startValidity, this.endValidity);
}
