import 'package:args/args.dart';
//import 'model/Person.dart';
//import 'Repository/PersonRepository.dart';

import 'dart:io';

const String version = '0.0.1';

void main(List<String> arguments) {
  
 // var personRepository = PersonRepository();
  
  stdout.writeln('Welcome to Spotter\nWhat do you want to handle? \n 1.Person \n 2.Vehicle \n 3.ParkingSpace \n 4.Parking \n 5.Close\nChoose alternative between (1-5) ');
  var input = stdin.readLineSync();
  stdout.writeln('You typed: $input');
 
if (input == '1'){
  stdout.writeln('You choosed to handle a person. What do you like to do? \n 1.Create new person \n 2.Show all persons \n 3.Update person \n 4.Delete person \n 5.Go back to main menu ');
}
else {
if (input == '2'){
 stdout.writeln('You choosed to handle a vehicle. What do you like to do? \n 1.Create new vehicle \n 2.Show all vehicles \n 3.Update vehicle \n 4.Delete vehicle \n 5.Go back to main menu ');
}
else {
  if (input == '3'){
    stdout.writeln('You choosed to handle a parkingspace. What do you like to do? \n 1.Create new parkingspace \n 2.Show all parkingspaces \n 3.Update parkingspace \n 4.Delete parkingspace \n 5.Go back to main menu ');
  }
  else {
  if (input == '4'){
    stdout.writeln('You choosed to handle a person. What do you like to do? \n 1.Create new parking \n 2.Show all parks  \n 3.Update parking \n 4.Delete parking \n 5.Go back to main menu ');
  }
  else {
  if (input == '5'){
    stdout.writeln('Go back to main menu');
  }
}
}
}


  //personRepository.add(Person(namn, personnummer))



  


}}
