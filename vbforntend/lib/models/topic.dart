import 'package:vbforntend/models/profile.dart';

class Topic {
  Topic({this.id, this.title});

  String? id;
  String? title;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(id: json['_id'], title: json['title']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
