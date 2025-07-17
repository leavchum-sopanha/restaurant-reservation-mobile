import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'table_model.dart';

class TableApiService {
  final String baseUrl = "http://10.0.2.2:8000/api/tables";

  Future<List<ModelTable>> read() async {
    try {
      http.Response response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> tableData = jsonResponse['data'];

        if (tableData == null || tableData is! List) {
          throw Exception("Invalid or null data received from API under 'data' key");
        }
        return tableData.map((e) => ModelTable.fromJson(e)).toList();
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  Future<bool> post(ModelTable item) async {
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

  Future<bool> update(ModelTable item) async {
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


