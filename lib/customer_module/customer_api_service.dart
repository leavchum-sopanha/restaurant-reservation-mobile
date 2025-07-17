import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'customer_model.dart';

class CustomerApiService {
  final String baseUrl = "http://10.0.2.2:8000/api/customers";

  Future<List<ModelCustomer>> read() async {
    try {
      http.Response response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> customerData = jsonResponse['data'];

        if (customerData == null || customerData is! List) {
          throw Exception("Invalid or null data received from API under 'data' key");
        }
        return customerData.map((e) => ModelCustomer.fromJson(e)).toList();
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  Future<bool> post(ModelCustomer item) async {
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

  Future<bool> update(ModelCustomer item) async {
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
}


