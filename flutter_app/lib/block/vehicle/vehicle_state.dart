part of 'vehicle_bloc.dart';

sealed class VehicleState {}

class VehiclesInitial extends VehicleState {}

class VehiclesLoading extends VehicleState {}

class VehiclesLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final Vehicle? pending;

  VehiclesLoaded({required this.vehicles, this.pending});
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({required this.message});
}