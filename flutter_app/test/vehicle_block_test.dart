import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
import 'package:flutter_app/model/Vehicle.dart';
import 'package:flutter_app/bloc/vehicle/vehicle_bloc.dart';

class MockVehicleRepo extends Mock implements VehicleHttpRepository {}


void main() {
  late VehicleBloc vehicleBloc;
  late MockVehicleRepo mockRepo;

  var vehicle1 = Vehicle.create("axd123", "Tesla", 1);
  var vehicle2 = Vehicle.create("edc456", "Ford", 1);

  final vehicles = [
    Vehicle.create("abc123", "Mazda", 1),
    Vehicle.create("edc456", "Ford", 1)
  ];

  setUp(() {
    mockRepo = MockVehicleRepo();
    vehicleBloc = VehicleBloc(repo: mockRepo);
  });

  tearDown(() {
    vehicleBloc.close();
  });
  group("create vehicle", () {
    blocTest<VehicleBloc, VehicleState>(
      "create vehicle",
      setUp: () {
        when(() => mockRepo.add(any())).thenAnswer((_) async => vehicle1);
        when(() => mockRepo.getAll()).thenAnswer((_) async => [...vehicles, vehicle1]);
      },
      build: () => vehicleBloc,
      seed: () => VehiclesLoaded(vehicles: [], pending: null),
      act: (bloc) => bloc.add(CreateVehicle(vehicle: vehicle1)),
      expect: () => [
        VehiclesLoaded(vehicles: [vehicle1], pending: vehicle1),
        VehiclesLoaded(vehicles: [...vehicles, vehicle1]),
      ],
      verify: (_) {
        verify(() => mockRepo.add(vehicle1)).called(1);
        verify(() => mockRepo.getAll()).called(1);
      },
    );
  });



}