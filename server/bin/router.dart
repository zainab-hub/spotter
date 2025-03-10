import 'dart:io';

import '../handlers/PersonHandler.dart';
import '../handlers/ParkingHandlar.dart';

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

    router.post('/persons', addPersonHandler); 
    router.get('/persons', getAllPersonHandler); 
    router.get('/persons/<id>', getPersonHandler); 
    router.put('/persons/<id>', updatePersonHandler); 
    router.delete('/persons/<id>', deletePersonHandler); 

    router.post('/parkings', addParkingHandler); 
    router.get('/parkings', getAllParkingHandler); 
    router.get('/parking/<id>', getParkingHandler); 
    router.put('/parkings/<id>', updateParkingHandler); 
    router.delete('/parkings/<id>', deleteParkingHandler); 

   
  }
}
