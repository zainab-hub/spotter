import 'package:args/args.dart';
import 'SpotterApp.dart';
import 'dart:io';

const String version = '0.0.1';

void main(List<String> arguments) {
  SpotterApp spotterApp = SpotterApp();
  spotterApp.mainMenu();
}
