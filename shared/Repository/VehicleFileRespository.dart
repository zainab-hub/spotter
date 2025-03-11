import 'dart:convert';
import 'dart:io';
import '../model/Vehicle.dart';

class VehicleFileRepository {
  String path = "./vehicles.json";

  Future<Vehicle> add(vehicle) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    try {
      String content = await file.readAsString();

      var json = jsonDecode(content) as List;

      json = [...json, vehicle.toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      throw Exception("Error writing to file");
    }

    return vehicle;
  }

  Future<Vehicle> getById(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    List<Vehicle> vehicles = await getAll();

    for (var vehicle in vehicles) {
      if (vehicle.id == id) {
        return vehicle;
      }
    }
    throw Exception("No vehicle found with id ${id}");
  }

  Future<List<Vehicle>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Vehicle> vehicles = (jsonDecode(content) as List)
        .map((json) => Vehicle.fromJson(json))
        .toList();

    return vehicles;
  }

  Future<Vehicle> update(Vehicle oldVehicle, Vehicle newVehicle) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var vehicles = await getAll();

    for (var i = 0; i < vehicles.length; i++) {
      if (vehicles[i].id == oldVehicle.id) {
        vehicles[i] = newVehicle;

        await file.writeAsString(
            jsonEncode(vehicles.map((vehicle) => vehicle.toJson()).toList()));

        return newVehicle;
      }
    }

    throw Exception("No vehicle found with id ${oldVehicle.id}");
  }

  Future<Vehicle> delete(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var vehicles = await getAll();

    for (var i = 0; i < vehicles.length; i++) {
      if (vehicles[i].id == id) {
        final vehicle = vehicles.removeAt(i);
        await file.writeAsString(
            jsonEncode(vehicles.map((vehicle) => vehicle.toJson()).toList()));
        return vehicle;
      }
    }

    throw Exception("No vehicle found with id ${id}");
  }
}
