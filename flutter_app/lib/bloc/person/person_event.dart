part of 'person_bloc.dart';

sealed class PersonEvent {}

class LoadPerson extends PersonEvent{}

class UpdatePerson extends PersonEvent {
      final Person person;

  UpdatePerson({required this.person});

}

class AddPerson extends PersonEvent {
      final Person person;

  AddPerson({required this.person});

}

class GetAllPerson extends PersonEvent {
      final Person person;

  GetAllPerson({required this.person});

}

class DeletePerson extends PersonEvent {
      final Person person;

  DeletePerson({required this.person});

}
//getAll

//update

//get

//delete