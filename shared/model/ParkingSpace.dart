class Parkingspace {
  String? adress;
  int id;
  int priceperhour;
  Parkingspace(this.adress, this.id, this.priceperhour);

  @override
  String toString() {
    return 'id: $id,adress: $adress, priceperhour: $priceperhour';
  }

  factory Parkingspace.fromJson(Map<String, dynamic> json) {
    return Parkingspace(json['id'], json['adress'], json['priceperhour']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "adress": adress,
      "priceperhour": priceperhour,
    };
  }
}
