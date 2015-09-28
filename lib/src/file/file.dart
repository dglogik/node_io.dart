part of node_io.file;

class FileMode {
  static const APPEND = const FileSystemEntityType._("APPEND");
  static const READ = const FileSystemEntityType._("READ");
  static const WRITE = const FileSystemEntityType._("WRITE");

  final String _type;

  const FileMode._(this._type);

  String toString() => _type;

  int get hashCode => _type.hashCode;
}


class File extends FileSystemEntity {
  final String path;

  factory File(String path) {
    return new File._(pathlib.normalize(path));
  }

  File._(this.path);

  factory File.fromUri(Uri uri) {
    return new File(uri.toFilePath(windows: Platform.isWindows));
  }

  Future<File> copy(String newPath) {
    return null;
  }

  File copySync(String newPath) {
    return null;
  }

  Future<File> create({bool recursive: false}) {
    return null;
  }

  void createSync({bool recursive: false}) {
    return null;
  }

  Future<DateTime> lastModified() {
    return null;
  }

  DateTime lastModifiedSync() {
    return null;
  }

  Future<int> length() {
    return null;
  }

  int lengthSync() {
    return 0;
  }

  /*
  Future<RandomAccessFile> open({FileMode mode: FileMode.READ}) {
    return null;
  }


  RandomAccessFile openSync({FileMode mode: FileMode.READ}) {
    return null;
  }
  */

  Stream<List<int>> openRead([int start, int end]) {
    return null;
  }

  IOSink openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) {
    return null;
  }

  Future<List<int>> readAsBytes() {
    var completer = new Completer<FileStat>();

    _fs.callMethod("readFile", [path, (error, JsObject buf) {
      completer.complete(bufToList(buf));
    }]);

    return completer.future;
  }

  List<int> readAsBytesSync() {
    var buf = _fs.callMethod("readFileSync", [path]);
    return bufToList(buf);
  }

  Future<List<String>> readAsLines({Encoding encoding: UTF8}) async {
    return (await readAsString(encoding: encoding)).split("\n");
  }

  List<String> readAsLinesSync({Encoding encoding: UTF8}) {
    return readAsStringSync(encoding: encoding).split("\n");
  }

  Future<String> readAsString({Encoding encoding: UTF8}) {
    return readAsBytes().then((bytes) {
      return encoding.decode(bytes);
    });
  }

  String readAsStringSync({Encoding encoding: UTF8}) {
    return encoding.decode(readAsBytesSync());
  }

  Future<File> rename(String newPath) {
    return null;
  }

  File renameSync(String newPath) {
    return null;
  }

  Future<File> writeAsBytes(List<int> bytes, {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: FileMode.APPEND
    // TODO: flush

    var completer = new Completer<FileStat>();

    _fs.callMethod("writeFile", [path, listToBuf(bytes), (error) {
      completer.complete(this);
    }]);

    return completer.future;
  }

  void writeAsBytesSync(List<int> bytes, {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: FileMode.APPEND
    // TODO: flush

    _fs.callMethod("writeFileSync", [path, listToBuf(bytes)]);
  }

  Future<File> writeAsString(String contents, {FileMode mode: FileMode.WRITE, Encoding encoding: UTF8, bool flush: false}) {
    return writeAsBytes(encoding.encode(contents));
  }

  void writeAsStringSync(String contents, {FileMode mode: FileMode.WRITE, Encoding encoding: UTF8, bool flush: false}) {
    return writeAsBytesSync(encoding.encode(contents));
  }
}