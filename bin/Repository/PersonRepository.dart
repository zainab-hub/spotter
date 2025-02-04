import '../model/Person.dart';

class PersonRepository {

  var persons =<Person>[];
  void add(Person person){

    persons.add(person);

 }
 List<Person> getAll(){
  return persons;
 }

}