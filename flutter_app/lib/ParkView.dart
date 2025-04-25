import 'package:flutter/material.dart';
import 'package:flutter_app/model/Vehicle.dart';
import 'package:flutter_app/model/Parking.dart';
import 'package:flutter_app/model/ParkingSpace.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
import 'package:flutter_app/repositories/ParkingSpaceHttpRepository.dart';

class ParkView extends StatefulWidget {
  const ParkView({super.key});

  @override
  State<ParkView> createState() => _ParkViewState();
}

class _ParkViewState extends State<ParkView> {
  late Future<List> _futureParkSpaces;
  final ParkingSpaceHttpRepository _httpRepository =
      ParkingSpaceHttpRepository();

  @override
  void initState() {
    super.initState();
    _futureParkSpaces = _httpRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose parking area')),
      body: FutureBuilder(
        future: _futureParkSpaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading ParkingSpaces'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ParkingSpaces found'));
          }

          final parkSpace = snapshot.data!;
          return ListView.builder(
            itemCount: parkSpace.length,
            itemBuilder: (context, index) {
              final space = parkSpace[index];
              return ListTile(
                title: Text(space.adress),
                subtitle: Text(space.priceperhour.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
    //     itemCount: ,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         leading: Icon(Icons.label),
    //         title: Text(items[index]),
    //         trailing: IconButton(
    //           icon: Icon(Icons.delete),
    //           onPressed: () {
    //             // Remove item from list
    //             setState(() {
    //               items.removeAt(index);
    //             });
    //           },
    //         ),
    //       );
    //     },
    //   ),
    //  // floatingActionButton: FloatingActionButton(
    //    // onPressed: () {
    //       // Add a new item
        //  setState(() {
       //     items.add('Item ${items.length + 1}');
      //    });
      //  },
     //   child: Icon(Icons.add),
  //    ),
   
  


