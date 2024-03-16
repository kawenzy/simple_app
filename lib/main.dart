import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penmetch/auth/register.dart';
import 'package:penmetch/firebase_options.dart';
import 'package:penmetch/layouts/layouts.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(23, 23, 23, 0))
  );
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'register_channel_group',
          channelKey: 'register_channel',
          channelName: 'register notifications',
          channelDescription: 'Notification channel for register',
        )
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  Future<Widget> onPage() async {
    if (_auth.currentUser != null) {
      await AwesomeNotifications().initialize(null, [
        NotificationChannel(
            channelKey: 'user${_auth.currentUser!.uid}',
            channelName: 'user',
            channelDescription: 'notifuser')
      ]);
      return const Layouts();
    } else {
      return const Register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: onPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: snapshot.data,
            );
          }
        });
  }
}