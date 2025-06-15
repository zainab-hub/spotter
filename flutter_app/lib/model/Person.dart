class Person {
  String id;
  String name;
  //int? personalNumber;
  String email;
  Person(this.id, this.name, this.email);

  @override
  String toString() {
    return 'name: $name, email: $email';
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['id'], json['name'], json['email']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email};
  }
}
