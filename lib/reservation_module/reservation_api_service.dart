import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'reservation_model.dart';

class ReservationApiService {
  final String baseUrl = "http://10.0.2.2:8000/api/reservations";

  // READ
  Future<List<ModelReservation>> read() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      debugPrint("Reservation response: ${response.body}");

      if (response.statusCode == 200) {
        try {
          // Use modelReservationFromJson with additional error handling
          return modelReservationFromJson(response.body);
        } catch (parseError) {
          debugPrint("Error parsing reservation data: $parseError");
          return [];
        }
      } else {
        throw Exception("Failed to load reservations: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Network error in reservation service: $e");
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  // CREATE
  Future<bool> post(ModelReservation item) async {
    debugPrint(item.toJson().toString());

    try {
      http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return true;
      } else {
        debugPrint("Error status code: ${response.statusCode}");
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  // UPDATE
  Future<bool> update(ModelReservation item) async {
    final url = "$baseUrl/${item.id}";
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return true;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  // DELETE
  Future<bool> delete(int id) async {
    final url = "$baseUrl/$id";
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {'content-type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 203) {
        debugPrint(response.body);
        return true;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  Future<String> rawJsonResponse() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return response.body; // raw JSON string
    } else {
      throw Exception("Failed to load reservations: ${response.statusCode}");
    }
  }
}
