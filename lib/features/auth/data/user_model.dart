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
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      image: json["image"] ?? '',
      address: json["address"] ?? '',
      visa: json["Visa"] ?? '',
      token: json["token"] ?? '',
    );
  }
}
