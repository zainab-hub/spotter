class Person {
  int? id;
  String? name;
  int? personalNumber;
  Person(this.id, this.name, this.personalNumber);

  @override
  String toString() {
    return 'name: $name, personalNumber: $personalNumber';
  }

  //Auto generat id
  factory Person.create(name, personalNumber) {
    return Person(DateTime.now().microsecondsSinceEpoch, name, personalNumber);
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'] as int,
      json['name'],
      json['personalNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "personalNumber": personalNumber};
  }
}
