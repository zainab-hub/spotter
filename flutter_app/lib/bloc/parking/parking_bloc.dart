import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/model/Parking.dart';

part 'parking_state.dart';
part 'parking_event.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingHttpRepository repo;

  ParkingBloc({required this.repo}) : super(ParkingsInitial()) {
    on<ParkingEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadParkings(): await getAllAndEmitLoaded(emit);
          case CreateParking(parking: final parking): await create(parking, emit);
          case DeleteParking(parking: final parking): await delete(emit, parking);
        }
      } catch (e) {
        emit(ParkingError(message: e.toString()));
      }
    });
  }
  Future<void> create(Parking parking, Emitter<ParkingState> emit) async {
    List<Parking> currentParkings = getCurrentParkings();
    currentParkings.add(parking);
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));
    await repo.add(parking);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> delete(Emitter<ParkingState> emit, Parking parking) async {
    List<Parking> currentParkings = getCurrentParkings();
    if (isClosed) return;
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));
    await repo.delete(parking.id);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> getAllAndEmitLoaded(Emitter<ParkingState> emit) async {
    final allParkings = await repo.getAll();
    emit(ParkingsLoaded(parkings: allParkings));
  }

  List<Parking> getCurrentParkings() {
    return switch (state) {
      ParkingsLoaded(:final parkings) => [...parkings],
      _ => <Parking>[],
    };
  }
}
