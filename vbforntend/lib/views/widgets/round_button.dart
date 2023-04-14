import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/auth_controller.dart';
import 'package:vbforntend/utils/lodable.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      this.height = 50,
      this.width = 200,
      this.isLoading = false,
      required this.ontap,
      required this.text,
      this.boxDecoration});
  final VoidCallback ontap;
  final String text;
  final double width;
  final double height;
  final BoxDecoration? boxDecoration;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return InkWell(
        onTap: ontap,
        child: Container(
          width: width,
          height: height,
          decoration: boxDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black12,
              ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: Text(
                  text,
                  style: const TextStyle(backgroundColor: Colors.white10),
                )),
        ));
  }
}
