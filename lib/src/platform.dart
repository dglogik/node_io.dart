part of node_io.common;

JsObject _process = require("process");

class Platform {
  static Map<String, String> get environment => () {
    var obj = _process["env"];
    var map = {};
    List<String> keys = context["global"]["Object"].callMethod("keys", [obj]);
    for (var key in keys) {
      map[key] = obj[key];
    }

    return map;
  }

  static List<String> get executableArguments => null;

  static Uri get script;

  static String get operatingSystem => _process["platform"];
  static String get localHostname;
  static String get pathSeparator;
  static String get packageRoot;
  static String get executable;
  static String get version => "${_process['version']} node.js";

  static int get numberOfProcessors;

  static get bool isAndroid => false;
  static get bool isLinux => _process["platform"] == "linux";
  static get bool isMacOS = _process["platform"] == "darwin";
  static get bool isWindows = _process["platform"] == "win32";
}
