import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AddUserDetailPage extends StatefulWidget {
  const AddUserDetailPage({Key? key}) : super(key: key);

  @override
  State<AddUserDetailPage> createState() => _AddUserDetailPageState();
}

class _AddUserDetailPageState extends State<AddUserDetailPage> {
  final controllerUsername = TextEditingController();
  final controllerName = TextEditingController();
  final controllerPhoneNo = TextEditingController();

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future updateDetail(Users user) async {
    final docUser = FirebaseFirestore.instance
        .collection("Account")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = user.toJson();
    await docUser.update(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(' Add user Details'),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: decoration('Name'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerUsername,
              decoration: decoration('Username'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerPhoneNo,
              decoration: decoration('PhoneNo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Save Details'),
              onPressed: () async {
                final detail = Users(
                    name: controllerName.text,
                    username: controllerUsername.text,
                    phoneNumber: controllerPhoneNo.text,
                    uid: FirebaseAuth.instance.currentUser!.uid);

                try {
                  await updateDetail(detail);
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("User details saved successfully")));
                } catch (e) {
                  print('Error saving document: $e');
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Error saving user details. Please try again later.")));
                }

                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
