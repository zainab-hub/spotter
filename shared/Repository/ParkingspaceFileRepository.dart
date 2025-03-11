import 'dart:convert';
import 'dart:io';
import '../model/Parkingspace.dart';


class ParkingSpaceFileRepository  {
  String path = "./parkingspaces.json";

  Future<Parkingspace> add(parkingspace) async {
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

      json = [...json, parkingspace.toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      
      throw Exception("Error writing to file");
    }

    return parkingspace;
  }


  Future<Parkingspace> getById(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    List<Parkingspace> parkingspaces = await getAll();

    for (var parkingspace in parkingspaces) {
      if (parkingspace.id == id) {
        return parkingspace;
      }
    }
    throw Exception("No parkingspace found with id ${id}");
  }

  Future<List<Parkingspace>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Parkingspace> parkingspaces = (jsonDecode(content) as List)
        .map((json) => Parkingspace.fromJson(json))
        .toList();

    return parkingspaces;
  }


  Future<Parkingspace> update(Parkingspace oldParkingspace, Parkingspace newParkingspace) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var parkingspaces = await getAll();

    for (var i = 0; i < parkingspaces.length; i++) {
      if (parkingspaces[i].id == oldParkingspace.id) {
        parkingspaces[i] = newParkingspace;

        await file.writeAsString(
            jsonEncode(parkingspaces.map((parkingspace) => parkingspace.toJson()).toList()));

        return newParkingspace;
      }
    }

    throw Exception("No parkingspace found with id ${oldParkingspace.id}");
  }


  Future<Parkingspace> delete(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var parkingspaces = await getAll();

    for (var i = 0; i < parkingspaces.length; i++) {
      if (parkingspaces[i].id == id) {
        final parkingspace = parkingspaces.removeAt(i);
        await file.writeAsString(
            jsonEncode(parkingspaces.map((parkingspace) => parkingspace.toJson()).toList()));
        return parkingspace;
      }
    }

    throw Exception("No parkingspace found with id ${id}");
  }
}
