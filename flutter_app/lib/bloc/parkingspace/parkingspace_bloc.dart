import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/repositories/ParkingspaceHttpRepository.dart';
import 'package:flutter_app/model/Parkingspace.dart';

part 'parkingspace_state.dart';
part 'parkingspace_event.dart';

class ParkingspaceBloc extends Bloc<ParkingspaceEvent, ParkingspaceState> {
  final ParkingSpaceHttpRepository repo;

  ParkingspaceBloc({required this.repo}) : super(ParkingspacesInitial()) {
    on<ParkingspaceEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadParkingspaces(): await getAllAndEmitLoaded(emit);
          case CreateParkingspace(parkingspace: final parkingspace): await create(parkingspace, emit);
          case DeleteParkingspace(parkingspace: final parkingspace): await delete(emit, parkingspace);
        }
      } catch (e) {
        emit(ParkingspaceError(message: e.toString()));
      }
    });
  }
  Future<void> create(Parkingspace parkingspace, Emitter<ParkingspaceState> emit) async {
    List<Parkingspace> currentParkingspaces = getCurrentParkingspaces();
    currentParkingspaces.add(parkingspace);
    emit(ParkingspacesLoaded(parkingspaces: currentParkingspaces, pending: parkingspace));
    await repo.add(parkingspace);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> delete(Emitter<ParkingspaceState> emit, Parkingspace parkingspace) async {
    List<Parkingspace> currentParkingspaces = getCurrentParkingspaces();
    if (isClosed) return;
    emit(ParkingspacesLoaded(parkingspaces: currentParkingspaces, pending: parkingspace));
    await repo.delete(parkingspace.id);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> getAllAndEmitLoaded(Emitter<ParkingspaceState> emit) async {
    final allParkingspaces = await repo.getAll();
    emit(ParkingspacesLoaded(parkingspaces: allParkingspaces));
  }

  List<Parkingspace> getCurrentParkingspaces() {
    return switch (state) {
      ParkingspacesLoaded(:final parkingspaces) => [...parkingspaces],
      _ => <Parkingspace>[],
    };
  }
}
