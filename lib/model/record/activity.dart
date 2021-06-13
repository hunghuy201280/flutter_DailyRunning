class Activity {
  String activityID;
  String dateCreated;
  String describe;
  double distance;
  int duration;
  List<LatLngArrayList> latLngArrayList;
  double pace;
  String pictureURI;
  String userID;

  Activity(
      {this.activityID,
      this.dateCreated,
      this.describe,
      this.distance,
      this.duration,
      this.latLngArrayList,
      this.pace,
      this.pictureURI,
      this.userID});

  Activity.fromJson(Map<String, dynamic> json) {
    activityID = json['activityID'];
    dateCreated = json['dateCreated'];
    describe = json['describe'];
    distance = json['distance'];
    duration = json['duration'];
    if (json['latLngArrayList'] != null) {
      latLngArrayList = [];
      json['latLngArrayList'].forEach((v) {
        latLngArrayList.add(new LatLngArrayList.fromJson(v));
      });
    }
    pace = json['pace'];
    pictureURI = json['pictureURI'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityID'] = this.activityID;
    data['dateCreated'] = this.dateCreated;
    data['describe'] = this.describe;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    if (this.latLngArrayList != null) {
      data['latLngArrayList'] =
          this.latLngArrayList.map((v) => v.toJson()).toList();
    }
    data['pace'] = this.pace;
    data['pictureURI'] = this.pictureURI;
    data['userID'] = this.userID;
    return data;
  }
}

class LatLngArrayList {
  double latitude;
  double longitude;

  LatLngArrayList({this.latitude, this.longitude});

  LatLngArrayList.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
