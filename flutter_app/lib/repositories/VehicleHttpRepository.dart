import 'dart:convert';
import 'dart:io';
import '../model/Vehicle.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleHttpRepository {
  String path = "./vehicles.json";

  Future<Vehicle> add(vehicle) async {
    await FirebaseFirestore.instance.collection("vehicle").doc(vehicle.id).set({
      "id": vehicle.id,
      "regestrationnumber": vehicle.regestrationnumber,
      "type": vehicle.type,
      "personid": vehicle.personid,
    });
    return vehicle;
  }

  Future<Vehicle> getById(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("vehicle").doc(id).get();

    final json = document.data();
    if (json == null) {
      throw Exception('Vehicle not found');
    }
    return Vehicle.fromJson(json);
  }

  Future<List<Vehicle>> getAll() async {
     final snapshot =
        await FirebaseFirestore.instance.collection("vehicle").get();

    return snapshot.docs.map((doc) => Vehicle.fromJson(doc.data())).toList();
   }

  // we will send id instead of old vehicle
 // Future<Vehicle> update(int id, Vehicle vehicle) async {
 //   await Future.delayed(Duration(seconds: 1));
 //   final uri = Uri.parse("${getBaseUrl()}/vehicles/$id");

 //   Response response = await http.put(
  //    uri,
   //   headers: {'Content-Type': 'application/json'},
   //   body: jsonEncode(vehicle.toJson()),
   // );

   // final json = jsonDecode(response.body);

  //  return Vehicle.fromJson(json);
//  }

  Future <Vehicle> delete(String id) async {
  final vehicle = getById(id);
    await FirebaseFirestore.instance.collection("vehicle").doc(id).delete();
    return vehicle;
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
