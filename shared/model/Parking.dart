

class Parking {
  int? id;
  String? vehicle;
  String? parkingspace;
  int? starttime;
  int? endtime;
  int? totalprice;
  Parking(this.id, this.vehicle, this.parkingspace, this.starttime, this.endtime, this.totalprice);

  @override
  String toString() {
    return 'vehicle: $vehicle, parkingspace: $parkingspace';
  }

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        json['id'] as int, 
        json['vehicle'], 
        json['parkingspace'], 
        json['starttime'] as int,
        json['endtime'] as int, 
        json['totalprice'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id, 
      "vehicle": vehicle, 
      "parkingspace": parkingspace, 
      "starttime": starttime, 
      "endtime": endtime, 
      "totalprice": totalprice
    };
  }
}