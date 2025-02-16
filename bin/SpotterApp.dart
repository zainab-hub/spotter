import 'Repository/PersonRepository.dart';
import 'Repository/VehicleRespository.dart';
import 'model/Person.dart';
import 'model/Vehicle.dart';
import 'dart:io';

class SpotterApp {
  PersonRepository personRepository = PersonRepository();
  Vehiclerespository vehicleRepository = Vehiclerespository();

  void mainMenu() {
    stdout.writeln(
        'Welcome to Spotter\nWhat do you want to handle? \n 1.Person \n 2.Vehicle \n 3.ParkingSpace \n 4.Parking \n 5.Close\nChoose alternative between (1-5) ');
    var input = stdin.readLineSync();
    stdout.writeln('You typed: $input');

    if (input == '1') {
      stdout.writeln(
          'You choosed to handle a person. What do you like to do? \n 1.Create new person \n 2.Show all persons \n 3.Update person \n 4.Delete person \n 5.Go back to main menu ');
      var input = stdin.readLineSync();
      if (input == '1') {
        stdout.writeln('Please enter name of person');
        String? name = stdin.readLineSync();
        stdout.writeln('Please enter personal number');
        String? personalNumberAsInput = stdin.readLineSync();
        // Convert string to integer
        int personalNumber = int.tryParse(personalNumberAsInput ?? '') ?? 0;

        Person newPerson = Person(name, personalNumber);
        personRepository.add(newPerson);
        mainMenu();
      }
      if (input == '2') {
        List allpersons = personRepository.getAll();
        allpersons.forEach((person) {
          stdout.writeln(person);
        });
        mainMenu();
      }
      if (input == '3') {
        stdout.writeln('Select number you want to update');
        List allpersons = personRepository.getAll();
        allpersons.asMap().forEach((index, person) {
          var personIndex = index + 1;
          stdout.writeln('$personIndex. $person');
        });
        //Read choice
        var input = stdin.readLineSync();
        int index = int.tryParse(input ?? '') ?? 0;
        var oldperson = personRepository.getById(index - 1);
        stdout.writeln('Enter the new name for the old person');
        String? newPerson = stdin.readLineSync();
        oldperson.name = newPerson;

        stdout.writeln('Enter the new personalnumber for the old person');
        String? newPersonalnumberInput = stdin.readLineSync();
        int newPersonalnumber = int.tryParse(newPersonalnumberInput ?? '') ?? 0;

        oldperson.personalNumber = newPersonalnumber;

        mainMenu();
      }
      if (input == '4') {
        stdout.writeln('Select number you want to delete');
        List allpersons = personRepository.getAll();
        allpersons.asMap().forEach((index, person) {
          var personIndex = index + 1;
          stdout.writeln('$personIndex. $person');
        });
        //Read choice
        var input = stdin.readLineSync();
        int index = int.tryParse(input ?? '') ?? 0;
        var removeperson = personRepository.getById(index - 1);
        personRepository.delete(removeperson);

        mainMenu();
      }
    }

    // } else  if (input == '5') {
    // stdout.writeln('Go back to main menu');
    // mainMenu();
    // }

    else if (input == '2') {
      stdout.writeln(
          'You choosed to handle a vehicle. What do you like to do? \n 1.Create new vehicle \n 2.Show all vehicles \n 3.Update vehicle \n 4.Delete vehicle \n 5.Go back to main menu ');
          var input = stdin.readLineSync();
      if (input == '1') {
        stdout.writeln('Please enter Vehicle Regestrationnumber');
        String? regestrationNumber = stdin.readLineSync();
        stdout.writeln('Please enter Vhicle type');
        String? type = stdin.readLineSync();
        stdout.writeln('Please enter Vehicle owner');
        List allpersons = personRepository.getAll();
        allpersons.asMap().forEach((index, person) {
          var personIndex = index + 1;
          stdout.writeln('$personIndex. $person');
        });
        var input = stdin.readLineSync();
        int index = int.tryParse(input ?? '') ?? 0;
        Person chooseOwner = personRepository.getById(index - 1);
        Vehicle newVehicle = Vehicle(regestrationNumber,type,chooseOwner) ;
        vehicleRepository.add(newVehicle);
        mainMenu();
      }
    

    } else if (input == '3') {
      stdout.writeln(
          'You choosed to handle a parkingspace. What do you like to do? \n 1.Create new parkingspace \n 2.Show all parkingspaces \n 3.Update parkingspace \n 4.Delete parkingspace \n 5.Go back to main menu ');
    } else if (input == '4') {
      stdout.writeln(
          'You choosed to handle a person. What do you like to do? \n 1.Create new parking \n 2.Show all parks  \n 3.Update parking \n 4.Delete parking \n 5.Go back to main menu ');
    } else if (input == '5') {
      stdout.writeln('Go back to main menu');
      mainMenu();
    }
  }
}
