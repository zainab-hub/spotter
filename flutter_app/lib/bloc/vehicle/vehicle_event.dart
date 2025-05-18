part of 'vehicle_bloc.dart';

sealed class VehicleEvent {}

//class UpdateItem extends VehicleEvent {
//  final Item item;
//
//  UpdateItem({required this.item});
//}

class LoadVehicles extends VehicleEvent {}

class CreateVehicle extends VehicleEvent {
  final Vehicle vehicle;

  CreateVehicle({required this.vehicle});
}

class DeleteVehicle extends VehicleEvent {
  final Vehicle vehicle;

  DeleteVehicle({required this.vehicle});
}