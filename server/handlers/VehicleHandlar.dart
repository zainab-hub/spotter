
import '../../shared/Repository/VehicleFileRespository.dart';
import '../../shared/model/Vehicle.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'dart:convert';


VehicleFileRepository repo = VehicleFileRepository();

Future<Response> addVehicleHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  Vehicle vehicle = Vehicle.fromJson(json);

  repo.add(vehicle);

  return Response.ok(
    jsonEncode(vehicle),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllVehicleHandler(Request request) async {
  List<Vehicle> vehicles = await repo.getAll();

  final payload = vehicles.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getVehicleHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;
  var vehicle = await repo.getById(idAsInt);

  return Response.ok(
    jsonEncode(vehicle),
    headers: {'Content-Type': 'application/json'},
  );

  // do better handling
  return Response.badRequest();
}

Future<Response> updatePersonHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;

  final data = await request.readAsString();
  final json = jsonDecode(data);
  Vehicle? newVehicle = Vehicle.fromJson(json);
  Vehicle oldVehicle = await repo.getById(idAsInt);
  repo.update(oldVehicle, newVehicle);

  return Response.ok(
    jsonEncode(newVehicle),
    headers: {'Content-Type': 'application/json'},
  );

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteVehicleHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;

  repo.delete(idAsInt);

  return Response.ok(
    jsonEncode("Removed"),
    headers: {'Content-Type': 'application/json'},
  );

  // TODO: do better handling
  return Response.badRequest();
}
