import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/admin_pages/show_admin_details_page.dart';
import 'package:mattbarber_app/barber_pages/show_barber_details.dart';
import 'package:mattbarber_app/pages/add_user_detail_page.dart';
import 'package:mattbarber_app/pages/show_user_detail_page.dart';

import '../components/my_button.dart';
import '../models/user.dart';

class BarberProfilePage extends StatefulWidget {
  const BarberProfilePage({Key? key}) : super(key: key);

  @override
  State<BarberProfilePage> createState() => _BarberProfilePageState();
}

class _BarberProfilePageState extends State<BarberProfilePage> {
  bool hasUserDetails = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Barber  Account'),
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
                  /* ElevatedButton(
                      child: Text('Add User Detail'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddUserDetailPage()));
                      }),
                  ElevatedButton(
                    child: Text('Delete user Detail'),
                    onPressed: () async {
                      final documentId = FirebaseAuth.instance.currentUser!
                          .uid; // replace with the actual document id

                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete the user details?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Account')
                                      .doc(documentId)
                                      .delete();
                                  // replace 'users' with the name of your collection in Firestore
                                  // this deletes the document with the given document id
                                  // Set the flag to indicate no user details exist
                                  setState(() {
                                    hasUserDetails = false;
                                  });
                                  // Close the confirmation dialog
                                  Navigator.pop(context);

                                  //SnackBar Message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "User details deleted successfully")));
                                } catch (e) {
                                  print('Error deleting document: $e');
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ), */
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    text: "Barber Account Details",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowBarberDetailsPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
