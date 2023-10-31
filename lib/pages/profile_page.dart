import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/pages/add_user_detail_page.dart';
import 'package:mattbarber_app/pages/show_user_detail_page.dart';

import '../components/my_button.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool hasUserDetails = false;

  @override
  void initState() {
    super.initState();
    checkUserDetailsExistence();
  }

  Future<void> checkUserDetailsExistence() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Account')
          .doc(user.uid)
          .get();
      final userData = userSnapshot.data();
      setState(() {
        hasUserDetails = (userData != null &&
            userData.containsKey('name') &&
            userData.containsKey('username') &&
            userData.containsKey('phone'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Account'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          const SizedBox(
            height: 250,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    text: "Add User Detail",
                    onTap: () async {
                      if (hasUserDetails) {
                        // Show a dialog if user details already exist
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('User Details Exist'),
                            content: Text(
                                'User details already exist. Do you want to overwrite them?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text('Add'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUserDetailPage(),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      checkUserDetailsExistence();
                                      Navigator.pop(
                                          context); // Remove the dialog from the widget tree
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUserDetailPage(),
                          ),
                        ).then((_) {
                          setState(() {
                            checkUserDetailsExistence();
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                      text: "Show User Detail",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowUserDetailsPage(),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
