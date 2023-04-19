import 'package:vbforntend/models/profile.dart';

class Space {
  String? id;
  dynamic owner;
  String? title;
  String? description;
  List? spaceTopics;
  String? scheduleDate;
  bool? isFinished;
  String? createdAt;
  String? updatedAt;

  Space(
      {this.id,
      this.owner,
      this.title,
      this.description = '',
      this.spaceTopics,
      this.scheduleDate,
      this.isFinished,
      this.createdAt,
      this.updatedAt});

  bool get isOwnerString => owner is String;

  static bool checkIsMap(dynamic data) => data is Map<String, dynamic>;

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
        id: json['_id'],
        owner: Space.checkIsMap(json['owner'])
            ? Profile.fromJson(json['owner'])
            : json['owner'],
        title: json['title'],
        description: json['description'],
        spaceTopics: json['space_topics'],
        scheduleDate: json['schedule_date'],
        isFinished: json['is_finished'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'owner': isOwnerString ? owner : owner.toMap(),
      'title': title,
      'description': description,
      'space_topics': spaceTopics,
      'schedule_date': scheduleDate,
      'is_finished': isFinished,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}
