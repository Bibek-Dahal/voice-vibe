import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/chat_controller.dart';
import 'package:vbforntend/controllers/user_controller.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/profile.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/profile_provider.dart';
import 'package:vbforntend/providers/socket_provider.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/utils/utils.dart';
import 'package:vbforntend/views/widgets/round_button.dart';
import 'package:vbforntend/services/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? file;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    print("inside init state callded ");
    // IO.Socket socket

    IO.Socket socket = context.read<SocketProvider>().socket;

    // context.read<SocketProvider>().socket = IO.io(
    //     'http://10.0.2.2:8000',
    //     IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
    //       'userid': context.read<ProfileProvider>().profile.id,
    //       'username': context.read<UserProvider>().user!.username
    //     }).build());

    socket.onConnect((_) {
      print('websocket connected');
      socket.emit('msg', 'test');
    });

    // socket.on('list online users', (data) {
    //   print(data);
    //   // List<Profile> profiles = [];
    //   List<Profile> profiles =
    //       List<Profile>.generate(data.length, (i) => Profile.fromJson(data[i]));
    //   // Profile.fromJson(data);
    //   print(profiles);
    //   onlineUserstreamController.sink.add(profiles);
    // });

    socket.onConnectError((error) => {print('socket error: $error ')});

    // TODO: implement initState
    NotificationServices notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();

    //save the fcm token of user
    notificationServices.getDeviceToken().then((value) {
      User user = context.read<UserProvider>().user!;
      UserController userController = context.read<UserController>();
      // print("username: ${user.username}");
      userController.updateUser(context, {
        'fcm_token': [value]
      }).then((value) {
        // print("succeded");
        if (userController.apiResponse.status == Status.ERROR) {
          Utils.showAlertBox(context, userController.apiResponse.error);
        } else if (userController.apiResponse.status == Status.COMPLETED) {
          print("fcm token updated successfully");
        }
      }).catchError(() => print("cant get token"));
      print(value);
    });

    notificationServices.setupInteractMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<UserProvider>().logout(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  Utils.pickImage().then((value) => file = value);
                },
                child: Text("pick image"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, RouteName.profileScreen);
                },
                child: Text("profile screen"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, RouteName.chatScreen);
                },
                child: Text("space screen"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, RouteName.chatHomeScreen);
                },
                child: Text("chat home screen"),
              ),
              Consumer<UserController>(
                builder: (context, value, child) => RoundButton(
                  isLoading: context.read<UserController>().isLoading,
                  text: "upload file",
                  ontap: () async {
                    // var a = {
                    //   'favourite_topics': ["Banepa"]
                    // };
                    context
                        .read<UserController>()
                        .upload(context, {'profile_pic': file});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
