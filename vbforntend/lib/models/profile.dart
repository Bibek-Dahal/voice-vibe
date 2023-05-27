import 'package:vbforntend/models/user.dart';

class Profile {
  const Profile(
      {this.id,
      this.user,
      this.followers,
      this.following,
      this.profile_pic,
      this.created_at,
      this.favourite_topics,
      this.updated_at});

  final String? id;
  final dynamic user;
  final List? followers;
  final List? following;
  final List? favourite_topics;
  final String? profile_pic;
  final String? created_at;
  final String? updated_at;

  Profile copyWith(
      {String? id,
      dynamic user,
      List? followers,
      List? following,
      String? profile_pic,
      String? created_at,
      List? favourite_topics,
      String? updated_at}) {
    return Profile(
        id: id ?? this.id,
        user: user ?? this.user,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        favourite_topics: favourite_topics ?? this.favourite_topics,
        profile_pic: profile_pic ?? this.profile_pic,
        created_at: created_at ?? this.created_at,
        updated_at: updated_at ?? this.updated_at);
  }

  bool get isUserId => user is String;

  bool get isUserObject => user is User;

  static bool checkIsMap(dynamic data) => data is Map<String, dynamic>;

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': isUserId ? user : user.toMap(),
      'followers': followers,
      'following': following,
      'profile_pic': profile_pic,
      'favourite_topics': favourite_topics,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    // print("profile from json called");
    return Profile(
        id: json['_id'],
        user: Profile.checkIsMap(json['user'])
            ? User.formJson(json['user'])
            : json['user'],
        followers: json['followers'],
        following: json['following'],
        favourite_topics: json['favourite_topics'],
        profile_pic: json['profile_pic'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }
}
