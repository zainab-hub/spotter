import '../../shared/Repository/ParkingspaceFileRepository.dart';
import '../../shared/model/Parkingspace.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'dart:convert';


ParkingSpaceFileRepository repo = ParkingSpaceFileRepository();

Future<Response> addParkingspaceHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  Parkingspace parkingspace = Parkingspace.fromJson(json);

  repo.add(parkingspace);

  return Response.ok(
    jsonEncode(parkingspace),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllParkingspaceHandler(Request request) async {
  List<Parkingspace> parkingspaces = await repo.getAll();

  final payload = parkingspaces.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getParkingspaceHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;
  var parkingspace = await repo.getById(idAsInt);

  return Response.ok(
    jsonEncode(parkingspace),
    headers: {'Content-Type': 'application/json'},
  );

  // do better handling
  return Response.badRequest();
}

Future<Response> updateParkingspaceHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;

  final data = await request.readAsString();
  final json = jsonDecode(data);
  Parkingspace? newParkingspace = Parkingspace.fromJson(json);
  Parkingspace oldparkingspace = await repo.getById(idAsInt);
  repo.update(oldparkingspace, newParkingspace);

  return Response.ok(
    jsonEncode(newParkingspace),
    headers: {'Content-Type': 'application/json'},
  );

}

Future<Response> deleteParkingspaceHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;

  repo.delete(idAsInt);

  return Response.ok(
    jsonEncode("Removed"),
    headers: {'Content-Type': 'application/json'},
  );

}
