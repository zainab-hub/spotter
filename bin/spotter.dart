import 'package:args/args.dart';
import 'model/Person.dart';
import 'dart:io';

const String version = '0.0.1';

void main(List<String> arguments) {
  stdout.writeln('Welcome to Spotter\nWhat do you want to handle? \n 1.Person \n 2.Vehicle \n 3.ParkingSpace \n 4.Parking \n 5.Close\nChoose alternative between (1-5) ');
  var input = stdin.readLineSync();
  stdout.writeln('You typed: $input');

  var name = stdin.readLineSync();



  


}
