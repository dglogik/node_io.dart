library node_io.file;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:js';

part 'src/file/event.dart';
part 'src/file/stat.dart';
part 'src/file/entity.dart';

part 'src/file/file.dart';
part 'src/file/directory.dart';

JsObject _fs = require('fs');

List<int> _bufToList(JsObject buf) {
  var bytes = <int>[];

  int length = buf["length"];
  for(int offset = 0; offset < length; offset++) {
    bytes.add(buf.callMethod('readUInt8', [offset]));
  }

  return bytes;
}

JsObject _listToBuf(List<int> bytes) {
  var length = bytes.length;
  var buf = new JsObject(context["Buffer"], [length]);

  var offset = 0;
  for(var byte in bytes) {
    if(offset >= length)
      break;
    buf.callMethod("writeUInt8", [byte, offset]);
    offset++;
  }

  return buf;
}