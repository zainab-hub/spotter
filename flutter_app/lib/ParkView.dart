import 'package:flutter/material.dart';
import '../model/Parkingspace.dart';
import '../model/Parking.dart';
import '../model/Vehicle.dart';
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
  final ParkingHttpRepository _parkingHttpRepository = ParkingHttpRepository();

  int? selectedParkingIndex; //Track selected item
  Parkingspace?
  selectedParking; // Parkingspace har only number 1, 2 (index). We want to name of parking space instead like "Sollentuna"
  int? selectedCar;
  Vehicle? selectedVehicle;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    _futureParkSpaces = _httpRepository.getAll();
  }

  Future<List<Vehicle>> getVehicles() {
    return _vehicleHttpRepository.getAll();
  }

  void _confirmParking() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Parking Confirmed!'),
            content: Text(
              'Location: ${selectedParking?.adress}\nCar:${selectedVehicle?.type} \nStart Time:${TimeOfDay.now().format(context)}  \nEnd Time: ${selectedEndTime?.format(context)}\nTotalPrice: ${calculateTotalPrice()} kr',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ok'),
              ),
            ],
          ),
    );
  }
  // To calculate total price
  int calculateTotalPrice() {
    final now = DateTime.now();

    // Convert TimeOfDay to DateTime (for today)
    final targetDateTime = selectedEndTimeAsDateTime();

    // If the time has already passed today, assume it's for tomorrow
    final adjustedTarget =
        targetDateTime.isBefore(now)
            ? targetDateTime.add(Duration(days: 1))
            : targetDateTime;

    final difference = adjustedTarget.difference(now);
    return (difference.inMinutes / 60.0 * selectedParking!.priceperhour).toInt(); // Convert minutes to hours as double
  }

  Parking createParking() {

    DateTime now = DateTime.now();

    DateTime targetDateTime = selectedEndTimeAsDateTime();
    final adjustedTarget =
      targetDateTime.isBefore(now)
          ? targetDateTime.add(Duration(days: 1))
          : targetDateTime;

    return Parking.create(
        selectedVehicle?.type, 
        selectedParking?.adress, 
        now.millisecondsSinceEpoch,
        adjustedTarget.millisecondsSinceEpoch, 
        calculateTotalPrice()
      );
  }

  DateTime selectedEndTimeAsDateTime() {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );
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
                subtitle: Text('${space.priceperhour.toString()} kr'),
                tileColor: isSelected ? Colors.green.withOpacity(0.3) : null,
                onTap: () {
                  setState(() {
                    selectedParkingIndex = index;
                    selectedParking = space;
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
             // ScaffoldMessenger.of(
              //  context,
             // ).showSnackBar(SnackBar(content: Text('Bottom Button Pressed')));
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('Start Parking'),
                        content: FutureBuilder(
                          future: getVehicles(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error loading cars.');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No cars available.');
                            }
                            List<Vehicle> vehicles = snapshot.data!;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Select your car",
                                  ),
                                  items:
                                      vehicles.map((car) {
                                        return DropdownMenuItem(
                                          value: car.id,
                                          child: Text(
                                            "${car.regestrationnumber} - ${car.type}",
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCar = value;
                                      selectedVehicle = vehicles.firstWhere(
                                        (vehicle) => vehicle.id == value,
                                      );
                                    });
                                  },
                                  value: selectedCar,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (time != null) {
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
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedCar == null ||
                                  selectedEndTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select car and end time!',
                                    ),
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).pop();
                            _parkingHttpRepository.add(createParking());
                              _confirmParking();
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
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
