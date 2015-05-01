library node_io.util;

import 'dart:js';

require(String input) => context.callMethod("require", [input]);