library node_io.common;

import 'dart:async';
import 'dart:convert';

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