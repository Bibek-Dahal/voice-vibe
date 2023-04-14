import 'package:vbforntend/models/user.dart';

class Profile {
  const Profile(
      {required this.id,
      required this.user,
      required this.followers,
      required this.following,
      this.profile_pic = 'kkl',
      required this.created_at,
      required this.favourite_topics,
      required this.updated_at});

  final String id;
  final String user;
  final List followers;
  final List following;
  final List favourite_topics;
  final String? profile_pic;
  final String created_at;
  final String updated_at;

  Profile copyWith(
      {String? id,
      String? user,
      List? followers,
      String? profile_pic,
      String? created_at,
      List? favourite_topics,
      String? updated_at}) {
    return Profile(
        id: id ?? this.id,
        user: user ?? this.user,
        followers: followers ?? this.followers,
        following: following,
        favourite_topics: favourite_topics ?? this.favourite_topics,
        profile_pic: profile_pic ?? this.profile_pic,
        created_at: created_at ?? this.created_at,
        updated_at: updated_at ?? this.updated_at);
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': user,
      'followers': followers,
      'following': following,
      'profile_pic': profile_pic,
      'favourite_topics': favourite_topics,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }

  factory Profile.fromMap(Map<String, dynamic> json) {
    return Profile(
        id: json['_id'],
        user: json['user'],
        followers: json['followers'],
        following: json['following'],
        favourite_topics: json['favourite_topics'],
        profile_pic: json['profile_pic'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }
}
