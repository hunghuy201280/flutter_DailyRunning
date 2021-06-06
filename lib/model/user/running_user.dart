class RunningUser {
  String displayName;
  String email;
  int point;
  bool gender;
  String userID;
  String dob;
  int height;
  int weight;
  String avatarUri;

  RunningUser(
      {this.displayName,
      this.email,
      this.point = 0,
      this.gender,
      this.userID,
      this.dob,
      this.height,
      this.weight,
      this.avatarUri});

  RunningUser.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    point = json['point'];
    gender = json['gender'];
    userID = json['userID'];
    dob = json['dob'];
    height = json['height'];
    weight = json['weight'];
    avatarUri = json['avatarUri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['point'] = this.point;
    data['gender'] = this.gender;
    data['userID'] = this.userID;
    data['dob'] = this.dob;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['avatarUri'] = this.avatarUri;
    return data;
  }
}
