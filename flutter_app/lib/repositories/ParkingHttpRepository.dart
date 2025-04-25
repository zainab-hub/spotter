import 'dart:convert';
import 'dart:io';
import '../model/Parking.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class ParkingFileRepository {
  String path = "./parking.json";

  Future<Parking> add(parking) async {
    final uri = Uri.parse("${getBaseUrl()}/parkings");

    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );

    final json = jsonDecode(response.body);

    return Parking.fromJson(json);
  }

  Future<Parking> getById(int id) async {
    final uri = Uri.parse("${getBaseUrl()}/parkings/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parking.fromJson(json);
  }

  Future<List<Parking>> getAll() async {
    final uri = Uri.parse("${getBaseUrl()}/parkings");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((parking) => Parking.fromJson(parking)).toList();
  }

  Future<Parking> update(int id, Parking parking) async {
    final uri = Uri.parse("${getBaseUrl()}/parkings/$id");

    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );

    final json = jsonDecode(response.body);

    return Parking.fromJson(json);
  }

  Future<Parking> delete(int id) async {
    final uri = Uri.parse("${getBaseUrl()}/parkings/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parking.fromJson(json);
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
