import 'dart:convert';
import 'dart:io';
import '../model/Parkingspace.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class ParkingSpaceHttpRepository {
  String path = "./parkingspace.json";

  Future<Parkingspace> add(parkingspace) async {
    final uri = Uri.parse("${getBaseUrl()}/parkingspaces");

    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingspace.toJson()),
    );

    final json = jsonDecode(response.body);

    return Parkingspace.fromJson(json);
  }

  Future<Parkingspace> getById(int id) async {
    final uri = Uri.parse("${getBaseUrl()}/parkingspaces/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parkingspace.fromJson(json);
  }

  Future<List<Parkingspace>> getAll() async {
    final uri = Uri.parse("${getBaseUrl()}/parkingspaces");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((person) => Parkingspace.fromJson(person)).toList();
  }

  Future<Parkingspace> update(
    int id,
    Parkingspace parkingspace,
  ) async {
    final uri = Uri.parse("${getBaseUrl()}/parkingspaces/$id");

    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingspace.toJson()),
    );

    final json = jsonDecode(response.body);

    return Parkingspace.fromJson(json);
  }

  Future<Parkingspace> delete(int id) async {
    final uri = Uri.parse("${getBaseUrl()}/parkingspaces/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parkingspace.fromJson(json);
  }

  String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080'; // For web browsers
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // For Android emulators
    } else {
      return 'http://localhost:8080'; // iOS simulator or desktop
    }
  }
}
