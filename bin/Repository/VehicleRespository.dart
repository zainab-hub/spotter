import '../model/Vehicle.dart';

class Vehiclerespository {

  var vehicles = <Vehicle>[];
  void add(Vehicle vehicle){
    vehicles.add(vehicle);
  }
List<Vehicle> getAll(){
  return vehicles;

}
Vehicle getById(id){
  return vehicles [id];
}
void update(Vehicle oldvehicle , Vehicle newvehicle) {
  int index = vehicles.indexOf(oldvehicle);
  if (index !=-1)
  {
    vehicles[index] = newvehicle; // Replace old vehicle with new vehicle
  }
  else {
    print("Vehicle is not found");
  }

  }

 // Method to remove an ID by value
void delete( Vehicle id) {
   vehicles.remove(id);
}

}