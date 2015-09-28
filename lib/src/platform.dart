part of node_io.common;

class Platform {
  static Map<String, String> get environment {
    var obj = _process["env"];
    var map = {};
    List<String> keys = context["global"]["Object"].callMethod("keys", [obj]);
    for (var key in keys) {
      map[key] = obj[key];
    }

    return map;
  }

  static List<String> get executableArguments => [];

  // static Uri get script;

  static String get operatingSystem => _process["platform"];
  // static String get localHostname;
  static String get pathSeparator {
    if (_sep == null) {
      _sep = require("path")["sep"];
    }
    return _sep;
  }

  static String _sep;
  // static String get packageRoot;
  // static String get executable;
  static String get version => "${_process['version']} node.js";

  // static int get numberOfProcessors;

  static bool get isAndroid => false;
  static bool get isLinux => _process["platform"] == "linux";
  static bool get isMacOS => _process["platform"] == "darwin";
  static bool get isWindows => _process["platform"] == "win32";
}
