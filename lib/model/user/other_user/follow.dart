import 'package:flutter/foundation.dart';

class Follow {
  String uid;

  Follow({
    @required this.uid,
  });

  Follow.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    return data;
  }
}
