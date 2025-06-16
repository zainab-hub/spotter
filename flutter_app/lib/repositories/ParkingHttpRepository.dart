import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/Vehicle.dart';

import '../model/Parking.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class ParkingHttpRepository {
  String path = "./parking.json";

  Future<Parking> add(parking) async {
    await FirebaseFirestore.instance.collection("parking").doc(parking.id).set({
      "id": parking.id,
      "vehicle": parking.vehicle,
      "starttime": parking.starttime,
      "endtime": parking.endtime,
      "totalprice": parking.totalprice,
      "parkingspace": parking.parkingspace,
    });
    return parking;
  }

  Future<Parking> getById(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("parking").doc(id).get();

    final json = document.data();
    if (json == null) {
      throw Exception('Person not found');
    }
    return Parking.fromJson(json);
  }

  Future<List<Parking>> getAll() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("parking").get();

    return snapshot.docs.map((doc) => Parking.fromJson(doc.data())).toList();
  }

  // Future<Parking> update(int id, Parking parking) async {
  // await Future.delayed(Duration(seconds: 1));
  //final uri = Uri.parse("${getBaseUrl()}/parkings/$id");

  // Response response = await http.put(
  //  uri,
  //  headers: {'Content-Type': 'application/json'},
  //  body: jsonEncode(parking.toJson()),
  //);

  // final json = jsonDecode(response.body);

  // return Parking.fromJson(json);
  // }

  Future<Future<Parking>> delete(String id) async {
    final parking = getById(id);
    await FirebaseFirestore.instance.collection("parking").doc(id).delete();
    return parking;
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
