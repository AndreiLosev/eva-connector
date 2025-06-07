import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin FileClient on CanDoRpc {
  Future<Object> fileGet(String path, [mode = FileGetMode.i]) async {
    return await baseCall('file.get', {'path': path, 'mode': mode.name});
  }

  /// content [String]|[List<int>]
  /// permissions [int]|[String]|[bool]
  Future<void> filePut(
    String path,
    Object content, [
    Object? permissions,
    FilePutExtract extract = FilePutExtract.no,
    bool? download,
  ]) async {
    await baseCall0('file.put', {
      'path': path,
      'content': content,
      if (permissions != null) 'permissions': permissions,
      'extract': extract,
      if (download != null) 'download': download,
    });
  }

  Future<void> fileUnlink(String path) async {
    await baseCall0('file.unlink', {'path': path});
  }

  Future<List<String>> list([
    String path = '.',
    String? masks,
    String? kind,
    bool recursive = false,
  ]) async {
    return await baseCall('list', {
      'path': path,
      'masks': masks,
      'kind': kind,
      'recursive': recursive,
    });
  }

  Future<String> sh(
    String c, [
    double? timeout,
    String? stdin,
    bool checkExitCode = false,
  ]) async {
    return await baseCall('sh', {
      'c': c,
      'timeout': timeout,
      'stdin': stdin,
      'check_exit_code': checkExitCode,
    });
  }

  Future<void> baseCall0(String method, [Map? params]) async {
    final rpcRes = await rpcCall0(
      'eva.filemgr.main',
      method,
      params: serialize(params),
    );

    await rpcRes.waitCompleted();
  }

  Future baseCall(String method, [Map? params]) async {
    final rpcRes = await rpcCall(
      'eva.filemgr.main',
      'file.get',
      params: serialize(params),
    );

    final frame = await rpcRes.waitCompleted();
    if (frame == null) {
      throw Exception('not found: $method');
    }

    return deserialize(frame.payload);
  }
}

enum FileGetMode { i, x, t, b }

enum FilePutExtract { no, tar, txz, tgz, tbz2, zip }
