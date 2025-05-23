part of 'parkingspace_bloc.dart';

sealed class ParkingspaceState extends Equatable {}

class ParkingspacesInitial extends ParkingspaceState {
  @override
  List<Object?> get props => [];
}

class ParkingspacesLoading extends ParkingspaceState {
  @override
  List<Object?> get props => [];
}

class ParkingspacesLoaded extends ParkingspaceState {
  final List<Parkingspace> parkingspaces;
  final Parkingspace? pending;

  ParkingspacesLoaded({required this.parkingspaces, this.pending});

  @override
  List<Object?> get props => [parkingspaces, pending];
}

class ParkingspaceError extends ParkingspaceState {
  final String message;

  ParkingspaceError({required this.message});

  @override
  List<Object?> get props => [message];
}
