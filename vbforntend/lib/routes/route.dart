import 'package:flutter/material.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/services/splash_screen_service.dart';
import 'package:vbforntend/views/home_screen.dart';
import 'package:vbforntend/views/auth/login_screen.dart';
import 'package:vbforntend/views/auth/otp_screen.dart';
import 'package:vbforntend/views/auth/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      //incase for passing arguments to screen
      // case RouteName.bcRatioResultScreen:
      //   return MaterialPageRoute(builder: (context) {
      //     print(settings.arguments);
      //     return DisplayBCRatio(
      //         data: settings.arguments as Map<String, dynamic>);
      //   });

      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case RouteName.otpScreen:
        return MaterialPageRoute(
            builder: (context) =>
                Otp(data: settings.arguments as Map<String, dynamic>));

      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (context) => const SignUp());
      default:
        return MaterialPageRoute(builder: (context) {
          return Text('Route Not Found');
        });
    }
  }
}
