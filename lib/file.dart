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