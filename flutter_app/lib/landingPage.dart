import 'package:flutter/material.dart';
import 'package:flutter_app/ParkView.dart';
import 'CarView.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
//import 'ParkView.dart';

class LandingPage extends StatelessWidget {
LandingPage({super.key});

final ValueNotifier<int> _index = ValueNotifier<int>(0);

final views = [CarView(), ParkView()];

 @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _index,
      builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Welcome")),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: views[value],
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value,
            onTap: (index) {
              // index is the index of the clicked navbar item
              _index.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.garage),
                label: 'Cars',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_parking_rounded),
                label: 'Parking',
              ),
            ],
          ),
        );
      },
    );
  }
}
