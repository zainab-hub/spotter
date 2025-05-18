import 'dart:convert';
import 'dart:io';
import '../model/Vehicle.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class VehicleHttpRepository {
  String path = "./vehicles.json";

  Future<Vehicle> add(vehicle) async {
    await Future.delayed(Duration(seconds: 1));
    final uri = Uri.parse("${getBaseUrl()}/vehicles");

    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<Vehicle> getById(int id) async {
    await Future.delayed(Duration(seconds: 1));
    final uri = Uri.parse("${getBaseUrl()}/vehicles/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<List<Vehicle>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    final uri = Uri.parse("${getBaseUrl()}/vehicles");
    final response = await http.get(uri);

    final json = jsonDecode(response.body);

    return (json as List).map((vehicle) => Vehicle.fromJson(vehicle)).toList();
  }

  // we will send id instead of old vehicle
  Future<Vehicle> update(int id, Vehicle vehicle) async {
    await Future.delayed(Duration(seconds: 1));
    final uri = Uri.parse("${getBaseUrl()}/vehicles/$id");

    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future <void> delete(int id) async {
    await Future.delayed(Duration(seconds: 1));
    final uri = Uri.parse("${getBaseUrl()}/vehicles/$id");

    await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
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
