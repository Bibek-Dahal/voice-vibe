import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/user_controller.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/utils/utils.dart';
import 'package:vbforntend/views/widgets/round_button.dart';
import 'package:vbforntend/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? file;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    NotificationServices notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();

    //save the fcm token of user
    notificationServices.getDeviceToken().then((value) {
      User user = context.read<UserProvider>().user!;
      UserController userController = context.read<UserController>();
      // print("username: ${user.username}");
      userController.updateUser(context, {'fcm_token': value}).then((value) {
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
