import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
