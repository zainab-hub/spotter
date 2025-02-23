import '../../shared/Repository/PersonRepository.dart';
import '../../shared/model/Person.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'dart:convert';

PersonRepository repo = PersonRepository();

Future<Response> addPersonHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  Person person = Person.fromJson(json);

  repo.add(person);

  return Response.ok(
    jsonEncode(person),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllPersonHandler(Request request) async {
  List<Person> persons = repo.getAll();

  final payload = persons.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getPersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    int idAsInt = int.tryParse(id ?? '') ?? 0;
    var person = await repo.getById(idAsInt);

    return Response.ok(
      jsonEncode(person),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // do better handling
  return Response.badRequest();
}

Future<Response> updatePersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    int idAsInt = int.tryParse(id ?? '') ?? 0;

    final data = await request.readAsString();
    final json = jsonDecode(data);
    Person? newPerson = Person.fromJson(json);
    Person oldperson = repo.getById(idAsInt);
    repo.update(oldperson, newPerson);

    return Response.ok(
      jsonEncode(newPerson),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deletePersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    int idAsInt = int.tryParse(id ?? '') ?? 0;

    repo.delete(idAsInt);

    return Response.ok(
      jsonEncode("Removed"),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}
