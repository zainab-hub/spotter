import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Parkingspace.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class ParkingSpaceHttpRepository {
  String path = "./parkingspace.json";

  Future<Parkingspace> add(parkingspace) async {
  await FirebaseFirestore.instance.collection("parkingspace").doc(parkingspace.id).set({
      "id": parkingspace.id,
      "adress": parkingspace.adress,
      "priceperhour": parkingspace.priceperhour,
    });
    return parkingspace;
  }

  Future<Parkingspace> getById(String id) async {
   final document =
        await FirebaseFirestore.instance.collection("parkingspace").doc(id).get();

    final json = document.data();
    if (json == null) {
      throw Exception('parkingspace not found');
    }
    return Parkingspace.fromJson(json);
  }

  Future<List<Parkingspace>> getAll() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("parkingspace").get();

    return snapshot.docs.map((doc) => Parkingspace.fromJson(doc.data())).toList();
  }

//  Future<Parkingspace> update(
 //  int id,
//    Parkingspace parkingspace,
  //) async {
   // final uri = Uri.parse("${getBaseUrl()}/parkingspaces/$id");

   // Response response = await http.put(
   //   uri,
   //   headers: {'Content-Type': 'application/json'},
    //  body: jsonEncode(parkingspace.toJson()),
  //  );

  //  final json = jsonDecode(response.body);

  //  return Parkingspace.fromJson(json);
 // }

  Future<Parkingspace> delete(String id) async {
  final vehicle = getById(id);
    await FirebaseFirestore.instance.collection("parkingspace").doc(id).delete();
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
