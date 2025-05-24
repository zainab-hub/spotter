import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/parking/parking_bloc.dart';
import 'package:flutter_app/bloc/parkingspace/parkingspace_bloc.dart';
import 'package:flutter_app/bloc/vehicle/vehicle_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/Parkingspace.dart';
import '../../model/Parking.dart';
import '../../model/Vehicle.dart';

class ParkView extends StatefulWidget {
  const ParkView({super.key});

  @override
  State<ParkView> createState() => _ParkViewState();
}

class _ParkViewState extends State<ParkView> {
  int? selectedParkingIndex; //Track selected item
  Parkingspace?
  selectedParking; // Parkingspace har only number 1, 2 (index). We want to name of parking space instead like "Sollentuna"
  int? selectedCar;
  Vehicle? selectedVehicle;
  TimeOfDay? selectedEndTime;

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
    return (difference.inMinutes / 60.0 * selectedParking!.priceperhour)
        .toInt(); // Convert minutes to hours as double
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
      calculateTotalPrice(),
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
      body: BlocBuilder<ParkingspaceBloc, ParkingspaceState>(
        builder: (context, state) {
          return switch (state) {
            ParkingspacesInitial() => Center(
              child: CircularProgressIndicator(),
            ),

            ParkingspacesLoading() => Center(
              child: CircularProgressIndicator(),
            ),

            ParkingspacesLoaded(:final parkingspaces, :final pending) =>
              ListView.builder(
                itemCount: parkingspaces.length,
                itemBuilder: (context, index) {
                  final space = parkingspaces[index];
                  final isSelected = selectedParkingIndex == index;
                  return ListTile(
                    title: Text(space.adress),
                    subtitle: Text(
                      '${space.priceperhour.toString()} kr',
                    ),
                    tileColor:
                        isSelected ? Colors.green.withOpacity(0.3) : null,
                    onTap: () {
                      setState(() {
                        selectedParkingIndex = index;
                        selectedParking = space;
                      });
                    },
                  );
                },
              ),
            ParkingspaceError(:final message) => Text(message),
          };
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('Start Parking'),
                        content: BlocBuilder<VehicleBloc, VehicleState>(
                          builder: (context, state) {
                            return switch (state) {
                              VehiclesInitial() => Center(
                                child: CircularProgressIndicator(),
                              ),
                              VehiclesLoading() => Center(
                                child: CircularProgressIndicator(),
                              ),
                              VehiclesLoaded(:final vehicles) =>
                                Column(
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
                                ),

                              VehicleError(:final message) =>Text(message),
                            };
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
                              context.read<ParkingBloc>().add(
                                CreateParking(parking: createParking()),
                              );
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
