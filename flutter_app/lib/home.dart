import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/auth/auth_bloc.dart';
import 'package:flutter_app/bloc/parking/parking_bloc.dart';
import 'package:flutter_app/bloc/parkingspace/parkingspace_bloc.dart';
import 'package:flutter_app/bloc/vehicle/vehicle_bloc.dart';
import 'package:flutter_app/repositories/PersonHttpRepository.dart';
import 'package:flutter_app/views/create_person_view.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/repositories/VehicleHttpRepository.dart';
import 'package:flutter_app/repositories/ParkingSpaceHttpRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'views/landing_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  var initializationSettingsIOS = const DarwinInitializationSettings();
  const WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
        appName: 'STI App', // Your app name, sync msix installer in pubspec
        appUserModelId: 'Com.Example.App',
        guid: 'TODO',
      );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    windows: initializationSettingsWindows,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await _configureLocalTimeZone();
  return flutterLocalNotificationsPlugin;
}

Future<void> requestPermissions() async {
  if (Platform.isIOS) {
    final impl =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    await impl?.requestPermissions(alert: true, badge: true, sound: true);
  }
  if (Platform.isMacOS) {
    final impl =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
    await impl?.requestPermissions(alert: true, badge: true, sound: true);
  }
  if (Platform.isAndroid) {
    final impl =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await impl?.requestNotificationsPermission();
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  flutterLocalNotificationsPlugin = await initializeNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestPermissions();
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
        BlocProvider(
          create: (context) => AuthBloc(repo: PersonHttpRepository()),
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
      context.read<AuthBloc>().login(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? errorMessage;

        if (state is AuthFailure) {
          errorMessage = state.error;
        }

        if (state is AuthInitial ||
            state is AuthNotAuth ||
            state is AuthFailure) {
          return Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (errorMessage != null) ...[
                      Text(errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter your name' : null,
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
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your password'
                                  : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(onPressed: _login, child: Text('Login')),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {

                        var androidDetails = AndroidNotificationDetails(
                          'channel_id', // Required
                          'channel_name', // Required
                          channelDescription: 'Your channel description',
                          importance: Importance.max,
                          priority: Priority.high,
                        );

                        var notificationDetails = NotificationDetails(
                          android: androidDetails,
                        );

                        await flutterLocalNotificationsPlugin.show(
                          0,
                          'zainab',
                          'hejsan!',
                          notificationDetails,
                        );  

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => createPersonPage()),
                        );
                      },
                      child: Text('New'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is AuthSuccess) {
          return LandingPage();
        } else if (state is AuthInProgress) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text("Unknown state"));
        }
      },
    );
  }
}
