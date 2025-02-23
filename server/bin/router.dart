import 'dart:io';

import '../handlers/PersonHandler.dart';

import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  // singleton constructor
  
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Router router;


  Future initialize() async {
    // Configure routes.
    router = Router();

    router.post('/persons', addPersonHandler); // create an item
    router.get('/persons', getAllPersonHandler); // get all items
    router.get('/persons/<id>', getPersonHandler); // get specific item
    router.put('/persons/<id>', updatePersonHandler); // update specific item
    router.delete('/persons/<id>', deletePersonHandler); // update specific item

   
  }
}
