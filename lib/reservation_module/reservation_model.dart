import 'dart:convert';
import 'package:app1/customer_module/customer_model.dart';
import 'package:app1/table_module/table_model.dart';

/// Parse list of reservations from raw JSON string
List<ModelReservation> modelReservationFromJson(String str) {
  try {
    final decoded = json.decode(str);

    if (decoded is Map<String, dynamic>) {
      if (!decoded.containsKey('data')) {
        print("JSON missing 'data' field");
        return [];
      }

      final rawList = decoded['data'];
      if (rawList == null) {
        print("'data' field is null");
        return [];
      }

      if (rawList is List) {
        final reservations = rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => ModelReservation.fromJson(e))
            .toList();
        print("Successfully parsed ${reservations.length} reservations.");
        return reservations;
      } else {
        print("'data' field is not a List but: ${rawList.runtimeType}");
        return [];
      }
    } else {
      print("JSON is not a Map");
      return [];
    }
  } catch (e) {
    print("Exception in modelReservationFromJson: $e");
    return [];
  }
}

/// Convert reservation list to JSON string
String modelReservationToJson(List<ModelReservation> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

/// Reservation Model
class ModelReservation {
  final int id;
  final int customerId;
  final int tableId;
  final String dateTime;
  final String note;
  final String? createdAt;
  final String? updatedAt;
  final ModelCustomer? customer;
  final ModelTable? table;

  ModelReservation({
    required this.id,
    required this.customerId,
    required this.tableId,
    required this.dateTime,
    required this.note,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.table,
  });

  factory ModelReservation.fromJson(Map<String, dynamic> json) {
    return ModelReservation(
      id: json["id"] ?? 0,
      customerId: json["customer_id"] ?? 0,
      tableId: json["table_id"] ?? 0,
      dateTime: json["date_time"] ?? '',
      note: json["note"] ?? '',
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      customer: json["customer"] != null
          ? ModelCustomer.fromJson(json["customer"])
          : null,
      table: json["table"] != null ? ModelTable.fromJson(json["table"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      "customer_id": customerId,
      "table_id": tableId,
      "date_time": dateTime,
      "note": note,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };

    if (customer != null) data["customer"] = customer!.toJson();
    if (table != null) data["table"] = table!.toJson();

    return data;
  }
}
