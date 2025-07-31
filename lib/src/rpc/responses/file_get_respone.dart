class FileGetRespone {
  final String contentType;
  final double modified;
  final String path;
  final int permissions;
  final int size;
  final List<int>? sha256;
  final String? text;
  final List<int>? content;

  FileGetRespone({
    required this.contentType,
    required this.modified,
    required this.path,
    required this.permissions,
    required this.size,
    this.sha256,
    this.text,
    this.content,
  });

  factory FileGetRespone.fromMap(Map<dynamic, dynamic> map) {
    return FileGetRespone(
      contentType: map['content_type'] as String,
      modified: (map['modified'] as num).toDouble(),
      path: map['path'] as String,
      permissions: map['permissions'] as int,
      size: map['size'] as int,
      sha256: map['sha256'] != null
          ? List<int>.from(map['sha256'] as List)
          : null,
      text: map['text'] as String?,
      content: map['content'] != null
          ? List<int>.from(map['content'] as List)
          : null,
    );
  }
}
