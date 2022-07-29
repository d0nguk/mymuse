import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  Timestamp date;
  String head;
  String body;

  Notice(this.date, this.head, this.body);

  Map<String, dynamic> toJson () => {
    "TimeStamp" : date,
    "NoticeHead" : head,
    "NoticeBody" : body,
  };

  Notice.fromJson(Map<String, dynamic> json)
    : date = json["TimeStamp"],
      head = json["NoticeHead"],
      body = json["NoticeBody"];
}