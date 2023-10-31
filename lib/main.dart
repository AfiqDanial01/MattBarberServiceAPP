import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mattbarber_app/colors.dart';
import 'package:mattbarber_app/pages/auth_page.dart';
import 'admin_pages/admin_homepage.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //klau nk tmbh theme tu balik buang const
      debugShowCheckedModeBanner: false,
      home: AuthPage(
          //klau nak tmbh MyHomePage(tittle: '')
          ),
      theme: ThemeData(primarySwatch: primary),
      //theme: ThemeData(primarySwatch: primary),
      //home: MyHomePage(title: 'Matt Barber'),
      routes: {
        'admin_homepage': (context) => AdminHomePage()
      },
    );
  }
}
