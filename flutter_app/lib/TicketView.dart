import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/parking/parking_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/Parkingspace.dart';
import '../model/Parking.dart';
import '../model/Vehicle.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';

class TicketView extends StatefulWidget {
  const TicketView({super.key});

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  Future future = ParkingHttpRepository().getAll();
  final ParkingHttpRepository _httpRepository = ParkingHttpRepository();

  String ticket(Parking parking) {
    return 'Location: ${parking.parkingspace}\nCar:${parking.vehicle} \nStart Time:${DateTime.fromMillisecondsSinceEpoch(parking.starttime)}  \nEnd Time: ${DateTime.fromMillisecondsSinceEpoch(parking.endtime)}\nTotalPrice: ${parking.totalprice} kr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tickets')),
      body: BlocBuilder<ParkingBloc, ParkingState>(
        builder: (context, state) {
          return switch (state) {
            ParkingsInitial() => Center(child: CircularProgressIndicator()),

            ParkingsLoading() => Center(child: CircularProgressIndicator()),

            ParkingsLoaded(:final parkings, :final pending) => ListView.builder(
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(parkings[index].vehicle),
                  subtitle: Text(ticket(parkings[index])),
                );
              },
            ),
            ParkingError(:final message) => Text(message),
          };
        },
      ),
    );
  }
}
