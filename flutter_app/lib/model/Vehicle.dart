class Vehicle {
  String id;
  String regestrationnumber;
  String type;
  int personid;
  Vehicle(this.id, this.regestrationnumber, this.type, this.personid);

  @override
  String toString() {
    return 'id: $id,regestrationnumber: $regestrationnumber, type: $type, personid: $personid';
  }

  //Auto generat id
  factory Vehicle.create(regestrationnumber, type, personid) {
    return Vehicle(
      DateTime.now().microsecondsSinceEpoch.toString(),
      regestrationnumber,
      type,
      personid,
    );
  }
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      json['id'],
      json['regestrationnumber'],
      json['type'],
      json['personid'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "regestrationnumber": regestrationnumber,
      "type": type,
      "personid": personid,
    };
  }
}
