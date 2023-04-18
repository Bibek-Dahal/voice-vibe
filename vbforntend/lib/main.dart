import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/auth_controller.dart';
import 'package:vbforntend/controllers/profile_controller.dart';
import 'package:vbforntend/controllers/user_controller.dart';
import 'package:vbforntend/firebase_options.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/routes/route.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //starts backgorund notification service
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      // ChangeNotifierProvider(create: (_) => AuthController()),
      // ChangeNotifierProvider(create: (_) => UserController()),
      ChangeNotifierProvider(create: (_) => ProfileController()),
    ],
    child: const MyApp(),
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data);
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
