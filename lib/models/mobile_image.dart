class MobileImage {
  int? id;
  String? url;
  int? mobileId;

  MobileImage({this.id, this.url, this.mobileId});

  MobileImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    mobileId = json['mobile_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['mobile_id'] = mobileId;
    return data;
  }
}
