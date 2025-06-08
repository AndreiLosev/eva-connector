class FileShResponse {
  final int exitcode;
  final String out;
  final String? err;

  FileShResponse(this.exitcode, this.out, this.err);

  factory FileShResponse.fromMap(Map map) {
    return FileShResponse(map['exitcode'], map['out'], map['err']);
  }
}
