import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Person.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class PersonHttpRepository {
  String path = "./persons.json";

  Future<Person> add(person) async {
    await FirebaseFirestore.instance.collection("person").doc(person.id).set({
      "id": person.id,
      "email": person.email,
      "name": person.name,
    });
    return person;
  }

  Future<Person> getById(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("person").doc(id).get();

    final json = document.data();
    if (json == null) {
      throw Exception('Person not found');
    }
    return Person.fromJson(json);
  }

 // Future<List<Person>> getAll() async {
   // final uri = Uri.parse("${getBaseUrl()}/persons");
   // final response = await http.get(
  //    uri,
  //    headers: {'Content-Type': 'application/json'},
  //  );

   // final json = jsonDecode(response.body);

   // return (json as List).map((person) => Person.fromJson(person)).toList();
 // }

  // Future<Person> update(int id, Person person) async {
  // final uri = Uri.parse("${getBaseUrl()}/persons/${id}");

  // Response response = await http.put(
  // uri,
  // headers: {'Content-Type': 'application/json'},
  //  body: jsonEncode(person.toJson()),
  // );

  // final json = jsonDecode(response.body);

  // return Person.fromJson(json);
  // }

  Future<Person> delete(String id) async {
    final person = getById(id);
    await FirebaseFirestore.instance.collection("person").doc(id).delete();
    return person;
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
