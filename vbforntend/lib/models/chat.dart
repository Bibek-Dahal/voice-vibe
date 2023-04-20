import 'package:vbforntend/models/profile.dart';

class Chat {
  Chat({this.id, this.sender, this.receiver, this.text, this.created_at});

  final String? id;
  final dynamic sender;
  final dynamic receiver;
  final String? text;
  final String? created_at;

  static bool checkIsMap(dynamic data) => data is Map<String, dynamic>;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json['id'],
        sender: Chat.checkIsMap(json['sender'])
            ? Profile.fromJson(json['sender'])
            : json['sender'],
        receiver: Chat.checkIsMap(json['receiver'])
            ? Profile.fromJson(json['receiver'])
            : json['receiver'],
        text: json['text'],
        created_at: json['created_at']);
  }
}
