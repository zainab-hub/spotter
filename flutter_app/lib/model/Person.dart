class Person {
  int? id;
  String? name;
  int? personalNumber;
  String email;
  Person(this.id, this.name, this.personalNumber, this.email);

  @override
  String toString() {
    return 'name: $name, personalNumber: $personalNumber, email: $email';
  }

  //Auto generat id
  factory Person.create(name, personalNumber, email) {
    return Person(
      DateTime.now().microsecondsSinceEpoch,
      name,
      personalNumber,
      email,
    );
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'] as int,
      json['name'],
      json['personalNumber'] as int,
      json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "personalNumber": personalNumber,
      "email": email,
    };
  }
}
