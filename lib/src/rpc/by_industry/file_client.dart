import 'package:eva_connector/src/rpc/by_industry/enums.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/file_get_respone.dart';
import 'package:eva_connector/src/rpc/responses/file_list_item_response.dart';
import 'package:eva_connector/src/rpc/responses/file_sh_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin FileClient on CanDoRpc {
  String defaultSvc = 'eva.filemgr.main';

  Future<FileGetRespone> fileGet(
    String path, [
    FileGetMode mode = FileGetMode.i,
  ]) async {
    final rpcRes = await _baseCall('file.get', {
      'path': path,
      'mode': mode.name,
    });
    return FileGetRespone.fromMap(rpcRes);
  }

  /// content [String]|[List<int>]
  /// permissions [int]|[String]|[bool]
  Future<void> filePut(
    String path,
    Object content, [
    FilePutExtract extract = FilePutExtract.no,
    Object? permissions,
    bool? download,
  ]) async {
    await _baseCall0('file.put', {
      'path': path,
      'content': content,
      if (permissions != null) 'permissions': permissions,
      'extract': extract.name,
      if (download != null) 'download': download,
    });
  }

  Future<void> fileUnlink(String path) async {
    await _baseCall0('file.unlink', {'path': path});
  }

  Future<List<FileListItemResponse>> list([
    String path = '',
    String? masks,
    String? kind,
    bool recursive = false,
  ]) async {
    final rawResposne = await _baseCall('list', {
      'path': path,
      if (masks != null) 'masks': masks,
      if (kind != null) 'kind': kind,
      'recursive': recursive,
    });

    return (rawResposne as List)
        .map((e) => FileListItemResponse.fromMap(e, path))
        .toList();
  }

  Future<FileShResponse> sh(
    String c, [
    double? timeout,
    String? stdin,
    bool checkExitCode = false,
  ]) async {
    final raw = await _baseCall('sh', {
      'c': c,
      'timeout': timeout,
      'stdin': stdin,
      'check_exit_code': checkExitCode,
    });

    return FileShResponse.fromMap(raw);
  }

  Future<void> _baseCall0(String method, [Map? params]) async {
    final rpcRes = await rpcCall(defaultSvc, method, params: serialize(params));

    await rpcRes.waitCompleted();
  }

  Future _baseCall(String method, [Map? params]) async {
    final rpcRes = await rpcCall(defaultSvc, method, params: serialize(params));

    final frame = await rpcRes.waitCompleted();
    if (frame == null) {
      throw Exception('not found: $method');
    }

    return deserialize(frame.payload);
  }
}
