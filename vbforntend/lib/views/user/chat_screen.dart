import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/chat_controller.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: ChangeNotifierProvider<ChatController>(
        create: (context) =>
            ChatController()..listChats(context, "643d9535511a28d0bf5773fc"),
        child: Consumer<ChatController>(builder: (context, value, child) {
          var apiResponse = value.apiResponse;
          if (apiResponse.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (apiResponse.status == Status.COMPLETED) {
            List<Chat> space_list = apiResponse.data as List<Chat>;

            return ListView.builder(
              itemCount: space_list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(space_list[index].text!),
                );
              },
            );
          } else {
            //dispaly error as you like
            return Container(
              child: Text("error"),
            );
          }
        }),
      ),
    );
  }
}
