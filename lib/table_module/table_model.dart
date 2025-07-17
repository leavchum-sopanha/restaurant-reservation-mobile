import 'dart:convert';

// import 'reservation_model.dart'; // If you have a shared Reservation model, consider importing it instead

// Parse JSON to List<ModelTable>
List<ModelTable> modelTableFromJson(String str) => List<ModelTable>.from(
      json.decode(str)["data"].map((x) => ModelTable.fromJson(x)),
    );

// Convert List<ModelTable> back to JSON
String modelTableToJson(List<ModelTable> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Table Model
class ModelTable {
  final int id;
  final int number;
  final int capacity;
  final String? createdAt;
  final String? updatedAt;
  final List<ModelReservation> reservations;

  ModelTable({
    required this.id,
    required this.number,
    required this.capacity,
    this.createdAt,
    this.updatedAt,
    required this.reservations,
  });

  factory ModelTable.fromJson(Map<String, dynamic> json) => ModelTable(
        id: json["id"],
        number: json["number"],
        capacity: json["capacity"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        reservations: json["reservations"] != null
            ? List<ModelReservation>.from(
                json["reservations"].map((x) => ModelReservation.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "capacity": capacity,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "reservations": List<dynamic>.from(reservations.map((x) => x.toJson())),
      };
}

// Reservation Model (used inside each table)
class ModelReservation {
  final int id;
  final int customerId;
  final int tableId;
  final String dateTime;
  final String note;
  final String? createdAt;
  final String? updatedAt;

  ModelReservation({
    required this.id,
    required this.customerId,
    required this.tableId,
    required this.dateTime,
    required this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelReservation.fromJson(Map<String, dynamic> json) =>
      ModelReservation(
        id: json["id"],
        customerId: json["customer_id"],
        tableId: json["table_id"],
        dateTime: json["date_time"],
        note: json["note"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "table_id": tableId,
        "date_time": dateTime,
        "note": note,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
