// ignore: file_names
class Person {
  String? name;
  int? personalNumber;
  Person(this.name, this.personalNumber);
  @override
  String toString() {
    return 'name: $name, personalNumber: $personalNumber';
  }
}
