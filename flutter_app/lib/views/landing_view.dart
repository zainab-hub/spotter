import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/auth/auth_bloc.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/views/park_view.dart';
import 'package:flutter_app/views/ticket_view.dart';
import 'package:provider/provider.dart';
import 'car_view.dart';
//import 'package:flutter_app/TicketView.dart';
//import 'ParkView.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  final views = [CarView(), ParkView(), TicketView()];

  void _logout(BuildContext context) {
    context.read<AuthBloc>().logout();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginApp()));
  }

  getName(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    if (state is AuthSuccess) {
      return state.name;
    } else {
      return 'Test';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _index,
      builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(getName(context)),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () => _logout(context),
              ),
            ],
          ),

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
              BottomNavigationBarItem(icon: Icon(Icons.garage), label: 'Cars'),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_parking_rounded),
                label: 'Parking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_sharp),
                label: 'Ticket',
              ),
            ],
          ),
        );
      },
    );
  }
}
