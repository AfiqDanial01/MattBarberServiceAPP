import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'confirm_edit_barbershop_page.dart';
import 'edit_user_detail_page.dart';

class EditBarbershopPage extends StatefulWidget {
  Map data;

  EditBarbershopPage({required this.data, Key? key}) : super(key: key);

  @override
  _EditBarbershopPageState createState() => _EditBarbershopPageState();
}

class _EditBarbershopPageState extends State<EditBarbershopPage> {
  // late Future<Users> _futureUser;
  bool hasUserDetails =
      true; // Add a boolean flag to track if user details exist

  @override
  void initState() {
    super.initState();
    // _getUserData();
  }

  // Future<void> _getUserData() async {
  //   final docUser = FirebaseFirestore.instance
  //       .collection("Account")
  //       .doc(FirebaseAuth.instance.currentUser?.uid);

  //   final snapshot = await docUser.get();

  //   if (snapshot.exists) {
  //     setState(() {
  //       _futureUser = Future.value(Users.fromJson(snapshot.data()!));
  //     });
  //   } else {
  //     throw Exception('User data not found');
  //   }
  // }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barberhop Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("barbershop")
              .doc(widget.data['branchId'])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map data = snapshot.data!.data() as Map;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: const Text('Branch'),
                    subtitle: Text(data['branch']),
                  ),
                  ListTile(
                    title: const Text('Address'),
                    subtitle: Text(data['address']),
                  ),
                  ListTile(
                    title: const Text('Opening Hours'),
                    subtitle: Text(data['opHour']),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(data['phoneNo']),
                  ),
                  ElevatedButton(
                    child: const Text('Edit Barbershop Details'),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ConfirmEditBarbershopPage(data: widget.data),
                      //   ),
                      // ).then((updatedData) {
                      //   if (updatedData != null) {
                      //     setState(() {
                      //       widget.data = updatedData;
                      //     });
                      //   }
                      // });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmEditBarbershopPage(data: data),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
