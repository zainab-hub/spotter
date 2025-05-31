import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/parking/parking_bloc.dart';
import 'package:flutter_app/bloc/parkingspace/parkingspace_bloc.dart';
import 'package:flutter_app/bloc/vehicle/vehicle_bloc.dart';
import 'package:flutter_app/views/create_person_view.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
import 'package:flutter_app/repositories/ParkingSpaceHttpRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/landing_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  VehicleBloc(repo: VehicleHttpRepository())
                    ..add(LoadVehicles()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ParkingBloc(repo: ParkingHttpRepository())
                    ..add(LoadParkings()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ParkingspaceBloc(repo: ParkingSpaceHttpRepository())
                    ..add(LoadParkingspaces()),
        ),
      ],
      child: MaterialApp(
        title: 'Simple Login',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String name;

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Placeholder action
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logging in as $email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 13, 126, 141),
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Please enter your name' : null,
                onChanged: (value) => name = value,
              ),
              SizedBox(height: 16),
               TextFormField(
               controller: _passwordController,
               obscureText: true,
               decoration: InputDecoration(
               labelText: 'Password',
               border: OutlineInputBorder(),
               ),
               validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
                ),
               SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LandingPage();
                      },
                    ),
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return createPersonPage();
                      },
                    ),
                  );
                },
                child: Text('New'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
