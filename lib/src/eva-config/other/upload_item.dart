sealed class UploadItem {
  final String target;
  final String secondory;
  final bool isValide;

  static const values = [
    UploadItemText('', ''),
    UploadItemUrl('', ''),
    UploadItemFile('', ''),
  ];

  static UploadItem fromConfig(Map<String, String> map) {
    final target = map['target'];
    final key = map.keys.firstWhere((e) => e != 'target');
    for (final v in values) {
      if (v.secondoryKey == key) {
        return v.copyWith(t: target, s: map[key]);
      }
    }

    throw Exception('invalid data for create UploadItem, data: $map');
  }

  String get secondoryKey;

  const UploadItem(this.target, this.secondory, [this.isValide = true]);

  Map<String, String> toConfig() => {'target': target, secondoryKey: secondory};

  UploadItem copyWith({String? t, String? s, bool? isV}) => switch (this) {
    UploadItemFile() => UploadItemFile(
      t ?? target,
      s ?? secondory,
      isV ?? isValide,
    ),
    UploadItemText() => UploadItemText(
      t ?? target,
      s ?? secondory,
      isV ?? isValide,
    ),
    UploadItemUrl() => UploadItemUrl(
      t ?? target,
      s ?? secondory,
      isV ?? isValide,
    ),
  };
}

class UploadItemText extends UploadItem {
  const UploadItemText(super.target, super.secondory, [super.isValide]);

  @override
  String get secondoryKey => 'text';
}

class UploadItemUrl extends UploadItem {
  const UploadItemUrl(super.target, super.secondory, [super.isValide]);

  @override
  String get secondoryKey => 'url';
}

class UploadItemFile extends UploadItem {
  const UploadItemFile(super.target, super.secondory, [super.isValide]);

  @override
  String get secondoryKey => 'src';
}
