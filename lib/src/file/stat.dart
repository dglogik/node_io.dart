part of node_io.file;

class FileStat {

  static const _notFound = const FileStat._invalid();

  static Future<FileStat> stat(String path) {
    var completer = new Completer<FileStat>();

    try {
      _fs.callMethod("stat", [path, (stat) {
        completer.complete(new FileStat._(stat));
      }]);
    } catch(_) {
      return _notFound;
    }

    return completer.future;
  }

  static FileStat statSync(String path) {
    try {
      var stat = _fs.callMethod("statSync", [path]);
      return new FileStat._(stat);
    } catch(_) {
      return _notFound;
    }
  }

  final DateTime accessed;
  final DateTime changed;
  final DateTime modified;

  final int mode;
  final int size;

  final FileSystemEntityType type;

  FileStat._(JsObject obj) :
    this.accessed = obj["atime"],
    this.changed = obj["ctime"],
    this.modified = obj["mtime"],
    this.mode = obj["mode"],
    this.size = obj["size"],
    this.type = obj.callMethod("isDirectory") == true ? FileSystemEntityType.DIRECTORY : obj.callMethod("isFile") == true ? FileSystemEntityType.FILE : FileSystemEntityType.NOT_FOUND;

  const FileStat._invalid() :
    this.accessed = null,
    this.changed = null,
    this.modified = null,
    this.mode = 0,
    this.size = -1,
    this.type = FileSystemEntityType.NOT_FOUND;

  String modeString() {
    var permissions = mode & 0xFFF;
    var codes = const ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
    var result = [];
    if ((permissions & 0x800) != 0) result.add("(suid) ");
    if ((permissions & 0x400) != 0) result.add("(guid) ");
    if ((permissions & 0x200) != 0) result.add("(sticky) ");
    result
      ..add(codes[(permissions >> 6) & 0x7])
      ..add(codes[(permissions >> 3) & 0x7])
      ..add(codes[permissions & 0x7]);
    return result.join();
  }
}