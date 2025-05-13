
import 'package:flutter_app/model/Vehicle.dart';
import 'package:bloc/bloc.dart';
import '../../repositories/VehicleHttpRepository.dart';

part 'vehicle_state.dart';
part 'vehicle_event.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleHttpRepository repo;

  VehicleBloc({required this.repo}) : super(VehiclesInitial()) {
    
    on<VehicleEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadVehicles(): await getAllAndEmitLoaded(emit);
          case CreateVehicle(vehicle: final vehicle): await create(vehicle, emit); 
          case DeleteVehicle(vehicle: final vehicle): await delete(emit, vehicle);
        }
      } catch (e) {
        emit(VehicleError(message: e.toString()));
      }
    });
  }

  Future<void> create(Vehicle vehicle, Emitter<VehicleState> emit) async {
    List<Vehicle> currenVehicles = getCurrentVehicles();
    currenVehicles.add(vehicle);
    emit(VehiclesLoaded(vehicles: currenVehicles, pending: vehicle));
    await repo.add(vehicle); 
    await getAllAndEmitLoaded(emit);
  }

  Future<void> delete(Emitter<VehicleState> emit, Vehicle vehicle) async {
    List<Vehicle> currenVehicles = getCurrentVehicles();  
    emit(VehiclesLoaded(vehicles: currenVehicles, pending: vehicle));
    await repo.delete(vehicle.id);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> getAllAndEmitLoaded(Emitter<VehicleState> emit) async {
    final allVehicles = await repo.getAll();
    emit(VehiclesLoaded(vehicles: allVehicles));
  }

  List<Vehicle> getCurrentVehicles() {
    return switch (state) {
      VehiclesLoaded(:final vehicles) => [...vehicles], _ => <Vehicle>[]
    };
  }

}
