class FileListItemResponse {
  final String path;
  final FileKind kind;

  FileListItemResponse(this.path, this.kind);

  factory FileListItemResponse.fromMap(Map map) {
    return FileListItemResponse(map['path'], map['kind']);
  }
}

enum FileKind { file, dir }
