import 'dart:convert';
import 'dart:io';

import '../model/Person.dart';
import '../shared.dart';


class PersonRepository implements RepositoryInterface<Person> {
  String path = "./persons.json";

  @override
  Future<Person> create(person) async {
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

      json = [...json, Person.toPersonEntity().toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      // TODO: Log error information so Dennis can check it later
      throw Exception("Error writing to file");
    }

    return person;
  }

  @override
  Future<Person> getById(String id) async {
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
      if (persons.id == id) {
        return person;
      }
    }
    throw Exception("No bag found with id ${id}");
  }

  Future<List<BagEntity>> _getAllEntities() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<BagEntity> bags = (jsonDecode(content) as List)
        .map((json) => BagEntity.fromJson(json))
        .toList();

    return bags;
  }

  @override
  Future<List<Bag>> getAll() async {
    var entities = await _getAllEntities();

    List<Bag> bags =
        await Future.wait(entities.map((entity) => entity.toBag()).toList());

    return bags;
  }

  @override
  Future<Bag> update(String id, Bag newBag) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var entities = await _getAllEntities();

    for (var i = 0; i < entities.length; i++) {
      if (entities[i].id == id) {
        entities[i] = newBag.toBagEntity();

        await file.writeAsString(
            jsonEncode(entities.map((bag) => bag.toJson()).toList()));

        return newBag;
      }
    }

    throw Exception("No bag found with id ${id}");
  }

  @override
  Future<Bag> delete(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    var entities = await _getAllEntities();

    for (var i = 0; i < entities.length; i++) {
      if (entities[i].id == id) {
        final entity = entities.removeAt(i);
        await file.writeAsString(
            jsonEncode(entities.map((bag) => bag.toJson()).toList()));
        return await entity.toBag();
      }
    }

    throw Exception("No bag found with id ${id}");
  }
}
