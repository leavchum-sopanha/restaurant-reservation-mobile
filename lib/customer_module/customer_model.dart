import 'dart:convert';

// Functions to parse and convert JSON
List<ModelCustomer> modelCustomerFromJson(String str) =>
    List<ModelCustomer>.from(
      json.decode(str)["data"].map((x) => ModelCustomer.fromJson(x)),
    );

String modelCustomerToJson(List<ModelCustomer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Customer Model
class ModelCustomer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? createdAt;
  final String? updatedAt;
  final List<dynamic> reservations;

  ModelCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.createdAt,
    this.updatedAt,
    required this.reservations,
  });

  factory ModelCustomer.fromJson(Map<String, dynamic> json) => ModelCustomer(
        id: json["id"],
        name: json["name"] ?? '',
        phone: json["phone"] ?? '',
        email: json["email"] ?? '',
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        reservations: json["reservations"] != null
            ? List<dynamic>.from(json["reservations"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "reservations": List<dynamic>.from(reservations.map((x) => x)),
      };
}
