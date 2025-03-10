//import '../../shared/Repository/PersonRepository.dart';
import '../../shared/Repository/ParkingRepository.dart';
import '../../shared/model/Parking.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'dart:convert';


ParkingFileRepository repo = ParkingFileRepository();

Future<Response> addParkingHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  Parking parking = Parking.fromJson(json);

  repo.add(parking);

  return Response.ok(
    jsonEncode(parking),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllParkingHandler(Request request) async {
  List<Parking> parkings = await repo.getAll();

  final payload = parkings.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getParkingHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;
  var parking = await repo.getById(idAsInt);

  return Response.ok(
    jsonEncode(parking),
    headers: {'Content-Type': 'application/json'},
  );

  // do better handling
  return Response.badRequest();
}

Future<Response> updateParkingHandler(Request request) async {
  String? id = request.params["id"];

  int idAsInt = int.tryParse(id ?? '') ?? 0;

  final data = await request.readAsString();
  final json = jsonDecode(data);
  Parking? newParking = Parking.fromJson(json);
  Parking oldparking = await repo.getById(idAsInt);
  repo.update(oldparking, newParking);

  return Response.ok(
    jsonEncode(newParking),
    headers: {'Content-Type': 'application/json'},
  );

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteParkingHandler(Request request) async {
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
