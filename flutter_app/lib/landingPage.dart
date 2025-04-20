import 'package:flutter/material.dart';
import 'CarView.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
//import 'ParkView.dart';

class LandingPage extends StatelessWidget {
LandingPage({super.key});

final ValueNotifier<int> _index = ValueNotifier<int>(0);

final views = [CarView()];

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

// //*class _LandingPageState extends State<LandingPage> {
//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome!")),
//       body: Center(child: views[index]),

//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (value) {
//           setState(() {
//             index = value;
//           });
//         },
//         currentIndex: index,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.garage), label: "Cars"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_parking),
//             label: "Parkings",
//           ),
//         ],
//       ),
//     );
//   }
// }
