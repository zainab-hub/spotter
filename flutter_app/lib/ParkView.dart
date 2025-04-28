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
  late Future<List> _futureVehicle;
  final ParkingSpaceHttpRepository _httpRepository = ParkingSpaceHttpRepository();
  final VehicleHttpRepository _vehicleHttpRepository = VehicleHttpRepository();

  int? selectedParkingIndex; //Track selected item
  int? selectedCar;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    _futureParkSpaces = _httpRepository.getAll();
  
  }

  Future<List<Vehicle>> getVehicles() {
    return _vehicleHttpRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking area')),
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
              final isSelected = selectedParkingIndex == index;
              return ListTile(
                title: Text(space.adress),
                subtitle: Text(space.priceperhour.toString()),
                tileColor: isSelected ? Colors.green.withOpacity(0.3) : null,
                onTap: () {
                  setState(() {
                    selectedParkingIndex = index;
                  });
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Your action when the button is pressed
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Bottom Button Pressed')));
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder:(context, setState) {
                      return AlertDialog(
                        title: Text('Start Parking'),
                        content: FutureBuilder(
                          future: getVehicles(), 
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                height: 100,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error loading cars.');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No cars available.');
                            }
                            List<Vehicle> vehicles = snapshot.data!;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField(
                                  decoration: const InputDecoration(labelText: "Select your car"),
                                  items: vehicles.map((car) {
                                    return DropdownMenuItem(
                                      value: car.id,
                                      child: Text("${car.regestrationnumber} - ${car.type}"),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCar = value;
                                    });
                                  },
                                  value: selectedCar
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                    );
                                    if (time !=null) {
                                      setState(() {
                                        selectedEndTime = time;
                                      });
                                    }
                                  },
                                  child: Text(
                                    selectedEndTime == null
                                    ? 'Select End Time'
                                    : 'End Time: ${selectedEndTime!.format(context)}',
                                  ),
                                ),
                              ],
                            );
                          }),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle confirm action
                              print(selectedEndTime);
                              print(selectedCar);
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                   });
                },
              );
            },
            child: Text('Start Parking'),
          ),
        ),
      ),
    );
  }
}
