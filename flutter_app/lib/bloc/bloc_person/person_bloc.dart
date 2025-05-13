import 'package:flutter_app/model/Person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_state.dart';
part 'person_event.dart';

class PersonBloc extends Bloc<PersonEvent,PersonState> {
  PersonBloc(): super(PersonInitial());
}