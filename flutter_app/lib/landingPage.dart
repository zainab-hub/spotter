import 'package:flutter/material.dart';
import 'CarPage.dart';
import 'ParkPage.dart';
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int index = 0;
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
  
      appBar:AppBar(title: Text("Welcome!")),
      body: Center(),
       bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.garage), label: "Cars"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: "Parkings",
          ),
        ],
      ),
    );
  }
}