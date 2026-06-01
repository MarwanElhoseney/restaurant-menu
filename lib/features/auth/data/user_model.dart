class UserModel {
  String name;
  String email;
  String? image;
  String? visa;
  String? token;
  String? address;

  UserModel({
    required this.name,
    required this.email,
    this.token,
    this.visa,
    this.address,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"]?.toString() ?? '',
      email: json["email"]?.toString() ?? '',
      image: json["image"]?.toString() ?? '',
      address: json["address"]?.toString() ?? '',
      visa: json["Visa"]?.toString() ?? '',
      token: json["token"]?.toString() ?? '',
    );
  }
}