import '../model/Person.dart';

class PersonRepository {

  var persons =<Person>[];
  void add(Person person){

    persons.add(person);

 }
 List<Person> getAll(){
  return persons;
 }
Person getById(id) {

  return persons[id];
}
void update(Person oldperson , Person newperson) {
  int index = persons.indexOf(oldperson);
  if (index !=-1)
  {
    persons[index] = newperson; // Replace old person with new person
  }
  else {
    print("Person is not found");
  }

  }

 // Method to remove an ID by value
void delete( Person id) {
   persons.remove(id);
}

}

