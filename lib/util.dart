library node_io.util;

import 'dart:js';

require(String input) => context.callMethod("require", [input]);

List<int> bufToList(JsObject buf) {
  var bytes = <int>[];

  int length = buf["length"];
  for (int offset = 0; offset < length; offset++) {
    bytes.add(buf.callMethod('readUInt8', [offset]));
  }

  return bytes;
}

JsObject listToBuf(List<int> bytes) {
  var length = bytes.length;
  var buf = new JsObject(context["Buffer"], [length]);

  var offset = 0;
  for (var byte in bytes) {
    if (offset >= length)
      break;
    buf.callMethod("writeUInt8", [byte, offset]);
    offset++;
  }

  return buf;
}

String normalizePath(String input) {
  return input.replaceAll("//", "/");
}
