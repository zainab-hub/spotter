part of 'person_bloc.dart';

sealed class PersonState{}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> person;
  
  PersonLoaded({required this.person});
}

class PersonError extends PersonState {
  final String message;

  PersonError({required this.message});
}
