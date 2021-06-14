import 'package:flutter/foundation.dart';

class Follow {
  String uid;
  String avatarUrl;
  String displayName;

  Follow(
      {@required this.uid,
      @required this.avatarUrl,
      @required this.displayName});

  Follow.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    avatarUrl = json['avatarUrl'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['avatarUrl'] = this.avatarUrl;
    data['displayName'] = this.displayName;
    return data;
  }
}
