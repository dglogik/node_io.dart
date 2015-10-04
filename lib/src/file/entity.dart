part of node_io.file;

class FileSystemEntityType {
  static const FILE = const FileSystemEntityType._("FILE");
  static const DIRECTORY = const FileSystemEntityType._("DIRECTORY");
  static const LINK = const FileSystemEntityType._("LINK");
  static const NOT_FOUND = const FileSystemEntityType._("NOT_FOUND");

  final String _type;

  const FileSystemEntityType._(this._type);

  String toString() => _type;

  int get hashCode => _type.hashCode;
}


abstract class FileSystemEntity {

  FileSystemEntity get absolute => null;

  bool get isAbsolute => false;

  Directory get parent => null;

  String get path => null;
  
  Uri get uri => new Uri.file(path);

  static Future<bool> identical(String path1, String path2) {
    return null;
  }

  static bool identicalSync(String path1, String path2) {
    return null;
  }

  static Future<bool> isDirectory(String path) {
    return null;
  }

  static bool isDirectorySync(String path) {
    return null;
  }

  static Future<bool> isFile(String path) {
    return null;
  }

  static bool isFileSync(String path) {
    return null;
  }

  static Future<bool> isLink(String path) {
    return null;
  }

  static bool isLinkSync(String path) {
    return null;
  }

  static String parentOf(String path) {
    return null;
  }

  static Future<FileSystemEntityType> type(String path, {bool followLinks: true}) {
    return null;
  }

  static FileSystemEntityType typeSync(String path, {bool followLinks: true}) {
    return null;
  }

  Future<FileSystemEntity> delete({bool recursive: false}) {
    return null;
  }

  FileSystemEntity deleteSync({bool recursive: false}) {
    return null;
  }

  Future<bool> exists() {
    return null;
  }

  bool existsSync() {
    return _fs.callMethod("existsSync", [path]);
  }

  Future<FileSystemEntity> rename(String newPath) {
    return null;
  }

  FileSystemEntity renameSync(String newPath) {
    return null;
  }

  Future<String> resolveSymbolicLinks() {
    return null;
  }

  String resolveSymbolicLinksSync() {
    return null;
  }

  Future<FileStat> stat() {
    return null;
  }

  FileStat statSync() {
    return null;
  }

  Stream<FileSystemEvent> watch({int events: FileSystemEvent.ALL, bool recursive: false}) {
    return null;
  }

  @override
  String toString() => "${runtimeType}(${path})";
}