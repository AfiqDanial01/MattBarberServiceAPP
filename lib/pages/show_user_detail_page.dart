import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'add_user_detail_page.dart';
import 'edit_user_detail_page.dart';

class ShowUserDetailsPage extends StatefulWidget {
  @override
  _ShowUserDetailsPageState createState() => _ShowUserDetailsPageState();
}

class _ShowUserDetailsPageState extends State<ShowUserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Account")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? userData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (userData != null &&
                userData.containsKey('name') &&
                userData.containsKey('username') &&
                userData.containsKey('phoneNumber') &&
                userData.containsKey('uid')) {
              Users user = Users(
                name: userData['name'],
                username: userData['username'],
                phoneNumber: userData['phoneNumber'],
                uid: userData['uid'],
              );

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Icon(Icons.person, size: 100),
                  SizedBox(height: 24),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(
                        text: FirebaseAuth.instance.currentUser?.email ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: userData['name']),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    enabled: false,
                    controller:
                        TextEditingController(text: userData['username']),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    enabled: false,
                    controller:
                        TextEditingController(text: userData['phoneNumber']),
                    decoration: InputDecoration(
                      labelText: 'PhoneNo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Text('Edit User Detail'),
                    onPressed: () async {
                      final editedUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserDetailsPage(user: user),
                        ),
                      ).then((value) => setState(() {}));
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'User details not found. Please add your user details first.',
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No user details found in the Account collection.'),
                  ElevatedButton(
                    child: Text('Add User Details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUserDetailPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
