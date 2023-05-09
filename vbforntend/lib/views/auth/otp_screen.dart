import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Otp extends StatefulWidget {
  const Otp({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //we cant use data directly
  // use widget.data['phone_num'] for accessing data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otp"),
      ),
    );
  }
}
