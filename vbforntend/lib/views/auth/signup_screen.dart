import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/auth_controller.dart';
import 'package:vbforntend/views/widgets/round_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp")),
      body: Center(
        child: RoundButton<AuthController>(
          ontap: () {
            var data = {
              'username': 'bibek743',
              'email': 'bibek256@gmail.com',
              'phone_num': '+9779860231990',
              'password': 'Admin@123',
              'repeat_password': 'Admin@123'
            };
            context.read<AuthController>().register(context, data);
          },
          text: "Sign Up",
        ),
      ),
    );
  }
}
