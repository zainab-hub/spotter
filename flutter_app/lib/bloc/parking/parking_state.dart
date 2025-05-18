part of 'parking_bloc.dart';

sealed class ParkingState extends Equatable {}

class ParkingsInitial extends ParkingState {
  @override
  List<Object?> get props => [];
}

class ParkingsLoading extends ParkingState {
  @override
  List<Object?> get props => [];
}

class ParkingsLoaded extends ParkingState {
  final List<Parking> parkings;
  final Parking? pending;

  ParkingsLoaded({required this.parkings, this.pending});

  @override
  List<Object?> get props => [parkings, pending];
}

class ParkingError extends ParkingState {
  final String message;

  ParkingError({required this.message});

  @override
  List<Object?> get props => [message];
}
