class User {
  late final String id;
  late final String username;
  late final String email;
  late final String phone_num;
  late final List fcm_token;
  late final String created_at;
  late final String updated_at;
  late final bool is_phn_verified;
  late final bool is_email_verified;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone_num,
      required this.fcm_token,
      required this.created_at,
      required this.updated_at,
      required this.is_phn_verified,
      required this.is_email_verified});

  User copyWith(
      {String? id,
      String? username,
      String? email,
      List? fcmToken,
      String? dateTime,
      String? phoneNum}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fcm_token: fcmToken ?? this.fcm_token,
      created_at: dateTime ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      phone_num: phoneNum ?? this.phone_num,
      is_phn_verified: is_phn_verified ?? this.is_phn_verified,
      is_email_verified: is_email_verified ?? this.is_email_verified,
    );
  }

//this method is used to convert user instance into Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data;
    data = {
      'id': id,
      'username': username,
      'email': email,
      'phone_num': phone_num,
      'fcmToken': fcm_token,
      'is_phn_verified': is_phn_verified,
      'is_email_verified': is_email_verified,
      'created_at': created_at,
      'updated_at': updated_at
    };

    return data;
  }

  /*this named constructor is used to convert Map into User model so that it can
  be easily used in views */
  factory User.formJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        phone_num: json['phone_num'],
        fcm_token: json['fcm_token'],
        is_phn_verified: json['is_phn_verified'],
        is_email_verified: json['is_email_verified'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "id:$id,username:$username,email:$email,phone_num:$phone_num,fcm_token:$fcm_token,created_at:$created_at";
  }
}
