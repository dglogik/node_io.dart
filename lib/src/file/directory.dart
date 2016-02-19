part of node_io.file;

class Directory extends FileSystemEntity {
  final String path;

  factory Directory(String path) {
    return new Directory._(normalizePath(path));
  }

  static Directory get current => new Directory(_process.callMethod("cwd"));

  Directory._(this.path);

  void createSync({bool recursive: false}) {
    _fs.callMethod("mkdirSync", [path]);
  }

  List<FileSystemEntity> listSync({bool recursive: false}) {
    var names = _fs.callMethod("readdirSync", [path]);
    var out = [];
    print(names);
    for (var name in names) {
      var p = "${path}${name}";
      JsObject stat = _fs.callMethod("statSync", [p]);
      if (stat.callMethod("isDirectory")) {
        out.add(new Directory(p));
      } else if (stat.callMethod("isFile")) {
        out.add(new File(p));
      }
    }
    return out;
  }
}
