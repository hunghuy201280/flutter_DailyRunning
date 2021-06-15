import 'package:daily_running/model/record/activity.dart';
import 'package:flutter/cupertino.dart';

class Post {
  String postID;
  List<Comment> comment;
  List<Like> like;
  Activity activity;
  String ownerID;
  String ownerAvatarUrl;
  String ownerName;

  Post({
    @required this.postID,
    this.comment = const [],
    this.like = const [],
    @required this.activity,
    @required this.ownerID,
    @required this.ownerAvatarUrl,
    @required this.ownerName,
  });

  Post.fromJson(Map<String, dynamic> json) {
    postID = json['postID'];
    if (json['comment'] != null) {
      comment = [];
      json['comment'].forEach((v) {
        comment.add(new Comment.fromJson(v));
      });
    }
    if (json['like'] != null) {
      like = [];
      json['like'].forEach((v) {
        like.add(new Like.fromJson(v));
      });
    }
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
        : null;
    ownerID = json['ownerID'];
    ownerAvatarUrl = json['ownerAvatarUrl'];
    ownerName = json['ownerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postID'] = this.postID;
    if (this.comment != null) {
      data['comment'] = this.comment.map((v) => v.toJson()).toList();
    }
    if (this.like != null) {
      data['like'] = this.like.map((v) => v.toJson()).toList();
    }
    if (this.activity != null) {
      data['activity'] = this.activity.toJson();
    }
    data['ownerID'] = this.ownerID;
    data['ownerAvatarUrl'] = this.ownerAvatarUrl;
    data['ownerName'] = this.ownerName;
    return data;
  }
}

class Comment {
  String commentID;
  String content;
  String dateCreated;
  String ownerID;
  String ownerName;
  String avatarUrl;

  Comment(
      {@required this.commentID,
      @required this.content,
      @required this.dateCreated,
      @required this.ownerID,
      @required this.ownerName,
      @required this.avatarUrl});

  Comment.fromJson(Map<String, dynamic> json) {
    commentID = json['commentID'];
    content = json['content'];
    dateCreated = json['dateCreated'];
    ownerID = json['ownerID'];
    ownerName = json['ownerName'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentID'] = this.commentID;
    data['content'] = this.content;
    data['dateCreated'] = this.dateCreated;
    data['ownerID'] = this.ownerID;
    data['ownerName'] = this.ownerName;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}

class Like {
  String userID;
  String avatarUrl;
  String userName;

  Like({this.userID, this.avatarUrl, this.userName});

  Like.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    avatarUrl = json['avatarUrl'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['avatarUrl'] = this.avatarUrl;
    data['userName'] = this.userName;
    return data;
  }
}
