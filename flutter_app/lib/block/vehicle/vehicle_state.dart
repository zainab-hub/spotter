part of 'vehicle_bloc.dart';

sealed class VehicleState extends Equatable  {}

class VehiclesInitial extends VehicleState {
  @override
  List<Object?> get props => [];
}

class VehiclesLoading extends VehicleState {
  @override
  List<Object?> get props => [];
}

class VehiclesLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final Vehicle? pending;

  VehiclesLoaded({required this.vehicles, this.pending});
  
  @override
  List<Object?> get props => [vehicles, pending];
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({required this.message});
  
  @override
  List<Object?> get props => [message];
}