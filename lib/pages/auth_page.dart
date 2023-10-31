import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mattbarber_app/admin_pages/admin_homepage.dart';
import 'package:mattbarber_app/login_page.dart';
import 'package:mattbarber_app/main.dart';
import 'package:mattbarber_app/pages/dummy.dart';
import 'package:mattbarber_app/pages/login_or_register_page.dart';
import 'package:mattbarber_app/pages/test_page.dart';

import '../barber_pages/barber_homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Account')
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Still waiting for user data
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData && snapshot.data!.exists) {
                    Map userData = snapshot.data?.data() as Map;

                    if (userData != null) {
                      final role = userData['role'];
                      print(userData);
                      if (role == 'admin') {
                        return AdminHomePage();
                      } else if (role == 'barber') {
                        return BarberHomePage();
                      } else {
                        return TestPage();
                      }
                    }
                  }

                  // Invalid user data or role not found
                  return TestPage();
                },
              );
            }
          }

          // User is not logged in or no user data available
          return LoginOrRegisterPage(
            onSignIn: (String email, String password) {},
          );
        },
      ),
    );
  }
}
