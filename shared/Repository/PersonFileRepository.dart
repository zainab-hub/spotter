import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import '../model/Person.dart';


class PersonFileRepository  {
  String path = "./persons.json";

  Future<Person> add(person) async {
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

      json = [...json, person.toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      
      throw Exception("Error writing to file");
    }

    return person;
  }


  Future<Person> getById(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    List<Person> persons = await getAll();

    for (var person in persons) {
      if (person.id == id) {
        return person;
      }
    }
    throw Exception("No person found with id ${id}");
  }

  Future<List<Person>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Person> persons = (jsonDecode(content) as List)
        .map((json) => Person.fromJson(json))
        .toList();

    return persons;
  }


  Future<Person> update(Person oldPerson, Person newPerson) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var persons = await getAll();

    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == oldPerson.id) {
        persons[i] = newPerson;

        await file.writeAsString(
            jsonEncode(persons.map((person) => person.toJson()).toList()));

        return newPerson;
      }
    }

    throw Exception("No person found with id ${oldPerson.id}");
  }


  Future<Person> delete(int id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var persons = await getAll();

    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == id) {
        final person = persons.removeAt(i);
        await file.writeAsString(
            jsonEncode(persons.map((person) => person.toJson()).toList()));
        return person;
      }
    }

    throw Exception("No person found with id ${id}");
  }
}
