class Parkingspace {
  String? adress;
  int id;
  int priceperhour;
  Parkingspace(this.id, this.adress, this.priceperhour);

  @override
  String toString() {
    return 'id: $id,adress: $adress, priceperhour: $priceperhour';
  }

  //Auto generat id
  factory Parkingspace.create(adress, priceperhour) {
    return Parkingspace(
      DateTime.now().microsecondsSinceEpoch,
      adress,
      priceperhour,
    );
  }
  factory Parkingspace.fromJson(Map<String, dynamic> json) {
    return Parkingspace(
      json['id'] as int,
      json['adress'],
      json['priceperhour'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "adress": adress, "priceperhour": priceperhour};
  }
}
