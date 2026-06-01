class ProductModel {
  int id;
  String name;
  String image;
  String desc;
  String price;
  String rate;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.desc,
    required this.price,
    required this.rate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      desc: json["description"],
      price: json["price"],
      rate: json["rating"],
    );
  }
}
