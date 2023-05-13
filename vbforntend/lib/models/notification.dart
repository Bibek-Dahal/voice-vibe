class NotificationModel {
  NotificationModel(
      {this.id, this.profile, this.title, this.body, this.created_at});

  final String? id;
  final String? profile;
  final String? title;
  final String? body;
  final String? created_at;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    print("form json called");
    // print("id,${json['id']}");
    return NotificationModel(
        id: json['id'],
        profile: json['profile'],
        title: json['title'],
        body: json['body'],
        created_at: json['created_at']);
  }
}
