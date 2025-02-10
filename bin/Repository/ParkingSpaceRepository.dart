import '../model/ParkingSpace.dart';

class Parkingspacerepository {

  var parkingspaces =<Parkingspace>[];
  void add(Parkingspace parkingspace){

    parkingspaces.add(parkingspace);

 }
 List<Parkingspace> getAll(){
  return parkingspaces;
 }
Parkingspace getById(id) {

  return parkingspaces[id];
}
void update(Parkingspace oldparkingspace , Parkingspace newparkingspace) {
  int index = parkingspaces.indexOf(oldparkingspace);
  if (index !=-1)
  {
    parkingspaces[index] = newparkingspace; // Replace old parkingspace with new parkingspace
  }
  else {
    print("Parkingspace is not found");
  }

  }

 // Method to remove an ID by value
void delete( Parkingspace id) {
   parkingspaces.remove(id);
}

}
