part of node_io.file;

class FileSystemEvent {

  static const int CREATE = 1 << 0;
  static const int MODIFY = 1 << 1;
  static const int DELETE = 1 << 2;
  static const int MOVE = 1 << 3;

  static const int ALL = CREATE | MODIFY | DELETE | MOVE;

  final bool isDirectory;
  final String path;
  final int type;

  FileSystemEvent._(this.isDirectory, this.path, this.type);
}
