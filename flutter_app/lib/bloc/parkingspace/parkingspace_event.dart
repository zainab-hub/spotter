part of 'parkingspace_bloc.dart';

sealed class ParkingspaceEvent {}

class LoadParkingspaces extends ParkingspaceEvent {}

class CreateParkingspace extends ParkingspaceEvent {
  final Parkingspace parkingspace;

  CreateParkingspace({required this.parkingspace});
}
class DeleteParkingspace extends ParkingspaceEvent {
  final Parkingspace parkingspace;

  DeleteParkingspace({required this.parkingspace});
}