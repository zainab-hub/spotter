// ignore: file_names
class Person {
  String? name;
  int? personalNumber;
  Person(this.name, this.personalNumber);

  @override
  String toString() {
    return 'name: $name, personalNumber: $personalNumber';
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        json['name'],
        json['personalNumber']
       );
  }

    Map<String, dynamic> toJson() {
    return {
      "name": name,
      "personalNumber": personalNumber
    };
  }
}
