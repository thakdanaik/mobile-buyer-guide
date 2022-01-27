class Mobile {
  int? id;
  double? rating;
  String? thumbImageURL;
  String? name;
  String? description;
  double? price;
  String? brand;

  Mobile({this.id, this.rating, this.thumbImageURL, this.name, this.description, this.price, this.brand});

  Mobile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating']?.toDouble();
    thumbImageURL = json['thumbImageURL'];
    name = json['name'];
    description = json['description'];
    price = json['price']?.toDouble();
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['thumbImageURL'] = thumbImageURL;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['brand'] = brand;
    return data;
  }
}
