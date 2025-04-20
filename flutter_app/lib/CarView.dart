import 'package:flutter/material.dart';
import 'package:flutter_app/model/Vehicle.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';

class CarView extends StatefulWidget {
  const CarView({super.key});

  // @override
  // Widget build(BuildContext context) {
  // TODO: implement build
  // throw UnimplementedError();
  //}
  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> {
  Future future = VehicleHttpRepository().getAll();
  final VehicleHttpRepository _httpRepository = VehicleHttpRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].regestrationnumber),
                  subtitle: Text(snapshot.data![index].type),
                  trailing: IconButton(
                    onPressed: () async {
                      await _httpRepository.delete(snapshot.data![index]);
                      setState(() {
                        future = _httpRepository.getAll();
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Vehicle? created = await showDialog<Vehicle>(
            context: context,
            builder: (context) {
              String regestrationnumber = "";
              String type ="";
              return AlertDialog(
                title: Text('Create new Vehicle'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Regestration Number'),
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
                      Navigator.pop(
                        context,
                        Vehicle.create(regestrationnumber, type, 1),
                      );
                    },

                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
          if (created != null) {
            // dispatch create item event
            await _httpRepository.add(created);
            setState(() {
              future = _httpRepository.getAll();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
