import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app/bloc/parking/parking_bloc.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_app/model/Parking.dart';

class MockParkingRepo extends Mock implements ParkingHttpRepository {}

void main() {
  late ParkingBloc parkingBloc;
  late MockParkingRepo mockRepo;

  var parking1 = Parking.create("Tesla", "Kista", 11,12, 50);
  var parking2 = Parking.create("Mazda", "Sollentuna", 10, 11, 20);
  //Parking.create(vehicle, parkingspace, starttime, endtime, totalprice)

  final parkings = [
    Parking.create("Toyota", "Solna", 9, 10, 30),
    Parking.create("BMW", "Märsta", 8,9, 60),
  ];

  setUpAll(() {
    mockRepo = MockParkingRepo();
    parkingBloc = ParkingBloc(repo: mockRepo);
    registerFallbackValue(
      Parking.create("Fallback", "Default", 0, 1, 0),
    );
  });

  group("create parking", () {
    blocTest<ParkingBloc, ParkingState>(
      "create parking",
      setUp: () {
        when(() => mockRepo.add(any())).thenAnswer((_) async => parking1);
        when(
          () => mockRepo.getAll(),
        ).thenAnswer((_) async => [...parkings, parking1]);
      },
      build: () => parkingBloc,
      seed: () => ParkingsLoaded(parkings: [], pending: null),
      act: (bloc) => bloc.add(CreateParking(parking: parking1)),
      wait: const Duration(seconds: 1), // ⏳ Let async completes before expect
      expect:
          () => [
            ParkingsLoaded(parkings: [parking1], pending: parking1),
            ParkingsLoaded(parkings: [...parkings, parking1]),
          ],
      verify: (_) {
        verify(() => mockRepo.add(parking1)).called(1);
        verify(() => mockRepo.getAll()).called(1);
      },
    );
  });
  
  group("delete parking", () {
    blocTest<ParkingBloc, ParkingState>(
      "delete parking",
      setUp: () {
        when(() => mockRepo.delete(parking1.id)).thenAnswer((_) async => {});
        when(() => mockRepo.getAll()).thenAnswer((_) async => [parking2]);
      },
      build: () => parkingBloc,
      seed: () => ParkingsLoaded(parkings: [parking1, parking2], pending: null),
      act: (bloc) => bloc.add(DeleteParking(parking: parking1)),
      wait: const Duration(seconds: 1), // ⏳ Let async completes before expect
      expect:
          () => [
            ParkingsLoaded(parkings: [parking1, parking2], pending: parking1),
            ParkingsLoaded(parkings: [parking2]),
          ],
      verify: (_) {
        verify(() => mockRepo.delete(parking1.id)).called(1);
        verify(() => mockRepo.getAll()).called(1);
      },
    );
  });
}
