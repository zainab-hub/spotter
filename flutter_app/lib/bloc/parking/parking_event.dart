part of 'parking_bloc.dart';

sealed class ParkingEvent {}

class LoadParkings extends ParkingEvent {}

class CreateParking extends ParkingEvent {
  final Parking parking;

  CreateParking({required this.parking});
}
class DeleteParking extends ParkingEvent {
  final Parking parking;

  DeleteParking({required this.parking});
}