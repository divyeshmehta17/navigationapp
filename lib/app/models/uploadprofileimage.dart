class UploadProfileImageFiles {
  String? key;
  String? url;

  UploadProfileImageFiles({this.key, this.url});

  UploadProfileImageFiles.fromJson(Map<String, dynamic> json) {
    key = json['key']?.toString();
    url = json['url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['url'] = url;
    return data;
  }
}

class UploadProfileImage {
  List<UploadProfileImageFiles?>? files;

  UploadProfileImage({this.files});

  UploadProfileImage.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      final v = json['files'];
      final arr0 = <UploadProfileImageFiles>[];
      v.forEach((v) {
        arr0.add(UploadProfileImageFiles.fromJson(v));
      });
      files = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (files != null) {
      final v = files;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['files'] = arr0;
    }
    return data;
  }
}
