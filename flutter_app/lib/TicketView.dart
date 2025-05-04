import 'package:flutter/material.dart';
import '../model/Parkingspace.dart';
import '../model/Parking.dart';
import '../model/Vehicle.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
import 'package:flutter_app/repositories/ParkingSpaceHttpRepository.dart';

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
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].vehicle),
                  subtitle: Text(ticket(snapshot.data![index])),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
