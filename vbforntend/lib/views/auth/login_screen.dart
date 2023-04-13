import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/auth_controller.dart';
import 'package:vbforntend/views/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: RoundButton<AuthController>(
          ontap: () => context.read<AuthController>().login(context,
              {'phone_num': '+9779864996631', 'password': 'Admin@123'}),
          text: "Login",
        ),
      ),
    );
  }
}
