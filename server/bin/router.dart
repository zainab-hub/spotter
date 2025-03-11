import 'dart:io';

import '../handlers/PersonHandler.dart';
import '../handlers/ParkingHandlar.dart';
import '../handlers/VehicleHandlar.dart';
import '../handlers/ParkingspaceHandlar.dart';
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

    router.post('/vehicles', addVehicleHandler);
    router.get('/vehicles', getAllVehicleHandler);
    router.get('/vehicles/<id>', getVehicleHandler);
    router.put('/vehicles/<id>', updateVehicleHandler);
    router.delete('/vehicles/<id>', deleteVehicleHandler);

    router.post('/parkingspaces', addParkingspaceHandler);
    router.get('/parkingspaces', getAllParkingspaceHandler);
    router.get('/parkingspaces/<id>', getParkingspaceHandler);
    router.put('/parkingspaces/<id>', updateParkingspaceHandler);
    router.delete('/parkingspaces/<id>', deleteParkingspaceHandler);
  }
}
