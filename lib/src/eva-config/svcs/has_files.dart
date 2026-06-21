import 'package:eva_connector/src/eva-config/other/upload_item.dart';

abstract interface class HasFiles {
  List<UploadItem> getFiles();

  void putFile(String name, List<int> content, [bool checkItYourself = false]);

  String basePath();
}
