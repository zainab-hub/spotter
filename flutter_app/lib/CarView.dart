
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Vehicle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'block/vehicle/vehicle_bloc.dart';

class CarView extends StatefulWidget {
  const CarView({super.key});
  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car')),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          return switch (state) {
            VehiclesInitial() => Center(
              child: CircularProgressIndicator(),
            ),
            VehiclesLoading() => Center(
              child: CircularProgressIndicator(),
            ),
            VehiclesLoaded(:final vehicles, :final pending) => ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = vehicles[index];
                bool isPending = vehicle.id == pending?.id;
                return ListTile(
                  title: Text(vehicles[index].regestrationnumber),
                  subtitle: Text(vehicles[index].type),
                  trailing: isPending ? CircularProgressIndicator() : IconButton(
                    onPressed: () async {
                      context.read<VehicleBloc>().add(DeleteVehicle(vehicle: vehicles[index]));
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
            }),
            VehicleError(:final message) => Text(message),
          };
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog<Vehicle>(
            context: context,
            builder: (context) {
              String regestrationnumber = "";
              String type = "";
              return AlertDialog(
                title: Text('Create new Vehicle'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Regestration Number',
                      ),
                      onChanged: (value) {
                        regestrationnumber = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Type'),
                      onChanged: (value) {
                        type = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<VehicleBloc>().add(CreateVehicle(vehicle: Vehicle.create(regestrationnumber, type, 1)));
                      Navigator.pop(context);
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
