import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/chat_controller.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/chat.dart';
import 'package:vbforntend/models/profile.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/profile_provider.dart';
import 'package:vbforntend/providers/socket_provider.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/temp_data.dart';
import 'package:vbforntend/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<Chat> chats = [
    Chat(
        id: "11242",
        text: "hello",
        sender: Profile(profile_pic: "aav", user: User(username: "bibek")),
        receiver: Profile(profile_pic: "aav", user: User(username: "rahul"))),
    Chat(
        id: "11242",
        text: "whats up",
        sender: Profile(profile_pic: "aav", user: User(username: "roshan")),
        receiver: Profile(profile_pic: "aav", user: User(username: "bij"))),
    Chat(
        id: "11242",
        text: "hey",
        sender: Profile(profile_pic: "aav", user: User(username: "rahul")),
        receiver: Profile(profile_pic: "aav", user: User(username: "jjk")))
  ];

  List<Profile> online = onlineUsers;
  StreamController<List<Profile>> onlineUserstreamController =
      StreamController<List<Profile>>();

  late IO.Socket socket;

  @override
  void initState() {
    socket = context.read<SocketProvider>().socket;
    socket.emit("list online users");

    // TODO: implement initState
    super.initState();
    // print("profile: ${context.read<ProfileProvider>().profile.id}");

    socket.on('list online users', (data) {
      print("List OnlineUser Called");
      // print(data);
      // List<Profile> profiles = [];
      List<Profile> profiles =
          List<Profile>.generate(data.length, (i) => Profile.fromJson(data[i]));
      // Profile.fromJson(data);
      print(profiles);
      onlineUserstreamController.sink.add(profiles);
    });
    context.read<ChatController>().listHomeScreenChats(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Home Screen"),
      ),
      body: Column(
        children: [
          Container(
            // height: 0.0,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<List<Profile>>(
                stream: onlineUserstreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        for (var profile in snapshot.data)
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteName.privateChatScreen,
                                  arguments: {'profile': profile});
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: profile.profile_pic != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.orange,
                                          backgroundImage:
                                              NetworkImage(profile.profile_pic),
                                        )
                                      : const CircleAvatar(
                                          backgroundColor: Colors.orange,
                                        ),
                                ),
                                Container(
                                    width: 80.0,
                                    child: Center(
                                      child: Text(
                                        profile.user.username,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                              ],
                            ),
                          )
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                // child: Row(
                //   children: [
                //     for (var profile in online)
                //       Column(
                //         children: [
                //           Container(
                //             padding: EdgeInsets.all(8),
                //             child: const CircleAvatar(
                //               backgroundColor: Colors.orange,
                //             ),
                //           ),
                //           Container(
                //               width: 50.0,
                //               child: Text(
                //                 profile.user.username,
                //                 overflow: TextOverflow.ellipsis,
                //               ))
                //         ],
                //       )
                //   ],
                // ),
              ),
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: online.length,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           margin: const EdgeInsets.only(top: 2.0),
          //           padding: const EdgeInsets.all(2),
          //           width: 50,
          //           height: 50,
          //           child: Column(
          //             children: [
          //               const CircleAvatar(
          //                 backgroundColor: Colors.orange,
          //               ),
          //               Text(online[index].user.username)
          //             ],
          //           ),
          //         );
          //       }),
          // ),
          Expanded(
            child: Container(
              child: Consumer<ChatController>(
                builder: (context, value, child) {
                  if (value.apiResponse.status == Status.COMPLETED) {
                    // print(value.apiResponse.data[0].receiver.id);
                    chats = value.apiResponse.data;
                    return Container(
                      child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            late String title;
                            late String subtitle;
                            Profile sender = chats[index].sender;
                            Profile receiver = chats[index].receiver;

                            print(sender.user.id);
                            print(receiver.user);

                            final User userModel =
                                context.read<UserProvider>().user!;
                            if (userModel.id == sender.user.id) {
                              title = receiver.user.username;
                            }
                            if (userModel.id == receiver.user.id) {
                              title = sender.user.username;
                            }

                            //check if msg is image
                            if (chats[index].type == 'image') {
                              if (sender.user.username == userModel.username) {
                                subtitle = "you sent an image";
                              } else {
                                subtitle =
                                    "${sender.user.username} sent you an image";
                              }
                            } else if (chats[index].type == 'file') {
                              if (sender.user.username == userModel.username) {
                                subtitle = "you sent an file";
                              } else {
                                subtitle =
                                    "${sender.user.username} sent you an image";
                              }
                            } else if (chats[index].type == 'audio') {
                              if (sender.user.username == userModel.username) {
                                subtitle = "you sent an audio clip";
                              } else {
                                subtitle =
                                    "${sender.user.username} sent you an audio clip";
                              }
                            } else {
                              subtitle = chats[index].text!;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.privateChatScreen,
                                      arguments: {'key': 'value'});
                                },
                                child: ListTile(
                                  title: Text(title),
                                  subtitle: Text(subtitle),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else if (value.apiResponse.status == Status.LOADING) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Utils.showAlertBox(context, value.apiResponse.error);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
