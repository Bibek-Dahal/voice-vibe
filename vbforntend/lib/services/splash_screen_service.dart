import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> isLoggedin(BuildContext context) async {
    UserProvider? userProvider =
        Provider.of<UserProvider>(context, listen: false);

    bool isLogged = await userProvider.isUserLogged();
    print("isLogged: $isLogged");
    if (isLogged) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, RouteName.homeScreen);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
      });
    }
    //   String? res = await userProvider.getToken();
    //   User? user = await userProvider.getUser();

    //   if (res != null && user != null) {

    //     Future.delayed(const Duration(seconds: 1), () {
    //       userProvider.setUser = user;
    //       Navigator.pushReplacementNamed(context, RouteName.homeScreen);
    //     });
    //   } else {
    //     Future.delayed(const Duration(seconds: 1), () {
    //       Navigator.pushReplacementNamed(context, RouteName.loginScreen);
    //     });
    //   }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("splash depen called");
    isLoggedin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
