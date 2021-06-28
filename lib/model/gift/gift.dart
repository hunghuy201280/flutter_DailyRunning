import 'package:flutter/cupertino.dart';

class Gift {
  String photoUri;
  String providerName;
  String giftDetail;
  int point;
  String iD;

  Gift({
    @required this.photoUri,
    @required this.providerName,
    @required this.giftDetail,
    @required this.point,
    @required this.iD,
  });

  Gift.fromJson(Map<String, dynamic> json) {
    photoUri = json['photoUri'];
    providerName = json['providerName'];
    giftDetail = json['giftDetail'];
    point = json['point'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoUri'] = this.photoUri;
    data['providerName'] = this.providerName;
    data['giftDetail'] = this.giftDetail;
    data['point'] = this.point;
    data['ID'] = this.iD;
    return data;
  }
}
