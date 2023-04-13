import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/user_controller.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/utils/utils.dart';
import 'package:vbforntend/views/widgets/round_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? file;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Utils.pickImage().then((value) => file = value);
                  },
                  child: Text("pick image")),
              RoundButton<UserController>(
                text: "upload file",
                ontap: () async {
                  var a = {
                    'favourite_topics': ["c", "d"]
                  };
                  context
                      .read<UserController>()
                      .upload(context, {'profile_pic': file}, a);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
