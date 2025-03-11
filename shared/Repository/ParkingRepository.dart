import 'dart:convert';
import 'dart:io';
import '../model/Parking.dart';


class ParkingFileRepository  {
  String path = "./parking.json";

  Future<Parking> add(parking) async {
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

      json = [...json, parking.toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      
      throw Exception("Error writing to file");
    }

    return parking;
  }


  Future<Parking> getById(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    List<Parking> parkings = await getAll();

    for (var parking in parkings) {
      if (parking.id == id) {
        return parking;
      }
    }
    throw Exception("No parking found with id ${id}");
  }

  Future<List<Parking>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Parking> parkings = (jsonDecode(content) as List)
        .map((json) => Parking.fromJson(json))
        .toList();

    return parkings;
  }


  Future<Parking> update(Parking oldParking, Parking newParking) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var parkings = await getAll();

    for (var i = 0; i < parkings.length; i++) {
      if (parkings[i].id == oldParking.id) {
        parkings[i] = newParking;

        await file.writeAsString(
            jsonEncode(parkings.map((parking) => parking.toJson()).toList()));

        return newParking;
      }
    }

    throw Exception("No parking found with id ${oldParking.id}");
  }


  Future<Parking> delete(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var parkings = await getAll();

    for (var i = 0; i < parkings.length; i++) {
      if (parkings[i].id == id) {
        final parking = parkings.removeAt(i);
        await file.writeAsString(
            jsonEncode(parkings.map((parking) => parking.toJson()).toList()));
        return parking;
      }
    }

    throw Exception("No parking found with id ${id}");
  }
}
