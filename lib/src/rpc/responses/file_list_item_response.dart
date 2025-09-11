class FileListItemResponse {
  final String path;
  final FileKind kind;

  FileListItemResponse(this.path, this.kind);

  factory FileListItemResponse.fromMap(Map map, [String parentPath = '']) {
    final path = parentPath.isEmpty
        ? map['path']
        : "$parentPath/${map['path']}";
    return FileListItemResponse(path, FileKind.fromString(map['kind']));
  }

  FileListItemResponse addParrent(String parent) =>
      FileListItemResponse('$parent/$path', kind);

  @override
  String toString() {
    final map = {'path': path, 'kind': kind};
    return "$runtimeType($map)";
  }
}

enum FileKind {
  file,
  dir;

  static FileKind fromString(String s) {
    return switch (s) {
      'file' => FileKind.file,
      'dir' => FileKind.dir,
      _ => throw Exception('undefinet FileKind type: $s'),
    };
  }
}
