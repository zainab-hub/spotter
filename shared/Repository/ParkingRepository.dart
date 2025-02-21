import '../model/Parking.dart';

class ParkingRepository {

  var parkings =<Parking>[];
  void add(Parking parking){

    parkings.add(parking);

 }
 List<Parking> getAll(){
  return parkings;
 }
Parking getById(id) {

  return parkings[id];
}
void update(Parking oldparking , Parking newparking) {
  int index = parkings.indexOf(oldparking);
  if (index !=-1)
  {
    parkings[index] = newparking; // Replace old parking with new parking
  }
  else {
    print("Parking is not found");
  }

  }

 // Method to remove an ID by value
void delete( Parking id) {
   parkings.remove(id);
}

}
