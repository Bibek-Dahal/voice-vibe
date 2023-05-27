import 'package:flutter/material.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/services/splash_screen_service.dart';
import 'package:vbforntend/views/home_screen.dart';
import 'package:vbforntend/views/auth/login_screen.dart';
import 'package:vbforntend/views/auth/otp_screen.dart';
import 'package:vbforntend/views/auth/signup_screen.dart';
import 'package:vbforntend/views/space/list_space.dart';
import 'package:vbforntend/views/user/chat_home_screen.dart';
import 'package:vbforntend/views/user/chat_screen.dart';
import 'package:vbforntend/views/user/private_chat_screen.dart';
import 'package:vbforntend/views/user/profile_view.dart';

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

      case RouteName.profileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());

      case RouteName.listSpaceScreen:
        return MaterialPageRoute(builder: (context) => const ListSpace());

      case RouteName.chatScreen:
        return MaterialPageRoute(builder: (context) => const ChatScreen());

      case RouteName.chatHomeScreen:
        return MaterialPageRoute(builder: (context) => const ChatHomeScreen());

      case RouteName.privateChatScreen:
        return MaterialPageRoute(
            builder: (context) => PrivateChatScreen(
                data: settings.arguments as Map<String, dynamic>));
      default:
        return MaterialPageRoute(builder: (context) {
          return Text('Route Not Found');
        });
    }
  }
}
