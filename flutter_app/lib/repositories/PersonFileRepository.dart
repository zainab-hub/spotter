import 'dart:convert';
import 'dart:io';
import '../model/Person.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class PersonFileRepository  {
  String path = "./persons.json";

  Future<Person> add(person) async {
    final uri = Uri.parse("http://10.0.2.2:8080/persons");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    final json = jsonDecode(response.body);

    return Person.fromJson(json);
  }


  Future<Person> getById(int id) async {
    final uri = Uri.parse("http://10.0.2.2:8080/persons/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Person.fromJson(json);
  }

  Future<List<Person>> getAll() async {
   final uri = Uri.parse("http://10.0.2.2:8080/persons");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((person) => Person.fromJson(person)).toList();
  }


  Future<Person> update(int id, Person person) async {
   final uri = Uri.parse("http://10.0.2.2:8080/persons/${id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    final json = jsonDecode(response.body);

    return Person.fromJson(json);
  }


  Future<Person> delete(int id) async {
     final uri = Uri.parse("http://10.0.2.2:8080/persons/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Person.fromJson(json);
  }
}
