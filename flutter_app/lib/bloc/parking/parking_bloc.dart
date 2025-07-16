import 'dart:ffi';
import 'dart:io';
import 'dart:math';
//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/repositories/ParkingHttpRepository.dart';
import 'package:flutter_app/model/Parking.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

part 'parking_state.dart';
part 'parking_event.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingHttpRepository repo;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ParkingBloc({
    required this.repo,
    required this.flutterLocalNotificationsPlugin,
  }) : super(ParkingsInitial()) {
    on<ParkingEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadParkings():
            await getAllAndEmitLoaded(emit);
          case CreateParking(parking: final parking):
            await create(parking, emit);
          case DeleteParking(parking: final parking):
            await delete(emit, parking);
        }
      } catch (e) {
        emit(ParkingError(message: e.toString()));
      }
    });
  }

  Future<void> create(Parking parking, Emitter<ParkingState> emit) async {
    List<Parking> currentParkings = getCurrentParkings();
    currentParkings.add(parking);
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));
    await repo.add(parking);
    await getAllAndEmitLoaded(emit);
    createNotification(parking);
  }

  Future<void> delete(Emitter<ParkingState> emit, Parking parking) async {
    List<Parking> currentParkings = getCurrentParkings();
    if (isClosed) return;
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));
    await repo.delete(parking.id);
    await getAllAndEmitLoaded(emit);
  }

  Future<void> getAllAndEmitLoaded(Emitter<ParkingState> emit) async {
    final allParkings = await repo.getAll();
    emit(ParkingsLoaded(parkings: allParkings));
  }

  List<Parking> getCurrentParkings() {
    return switch (state) {
      ParkingsLoaded(:final parkings) => [...parkings],
      _ => <Parking>[],
    };
  }

  void createNotification(Parking parking) async {
    await requestPermissions();
    var when = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local,
      parking.endtime,
    );

    var formatedWhen = DateFormat.Hm().format(when);

    var id = Random().nextInt(10000)+1;
    var id2 = Random().nextInt(10000)+1;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Parking',
      'Your will parking end in $formatedWhen!',
      when.add(Duration(minutes: -10)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          parking.id, // Required
          'parking', // Required
          channelDescription: 'parking channel',
          importance: Importance.max,
          priority: Priority.high,
          when: when.millisecondsSinceEpoch,
          usesChronometer: true,
          chronometerCountDown: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id2,
      'Parking ended',
      'Your parking time has ended.',
      when,
      NotificationDetails(
        android: AndroidNotificationDetails(
          parking.id,
          'parking',
          channelDescription: 'parking channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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
}
