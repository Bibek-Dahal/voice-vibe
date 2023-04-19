import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/profile_controller.dart';
import 'package:vbforntend/controllers/user_controller.dart';

import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/profile.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileController>(context, listen: false)
        .fetchProfile(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("did depen called");

    // user = Provider.of<UserProvider>(context, listen: false).user;
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    user = context.read<UserProvider>().user;
    print("profile build called");
    return Scaffold(
        appBar: AppBar(
          title: Text("profile"),
        ),
        body: Container(
          child: Consumer<ProfileController>(builder: (_, value, child) {
            if (value.apiResponse.status == Status.LOADING) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            } else {
              Profile profile = value.apiResponse.data!;
              return ListTile(
                title: Text(user!.username!),
                trailing: profile.profile_pic != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profile.profile_pic!))
                    : const CircleAvatar(
                        backgroundColor: Colors.amber,
                      ),
              );
            }
          }),
        ));
  }
}
