import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowBarberDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // If the user is not logged in, you can handle it accordingly
      return Center(
        child: Text('User not logged in.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Barber Details'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('Account')
            .doc(currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              DocumentSnapshot<Map<String, dynamic>>? barberDoc = snapshot.data;

              if (barberDoc != null) {
                final barberData = barberDoc.data();
                final barberEmail = barberData?['email'];
                final barberPassword = barberData?['password'];
                final barberName = barberData?['name'];

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Icon(Icons.person, size: 100),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: barberEmail),
                      decoration: decoration('Email'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: barberPassword),
                      decoration: decoration('Password'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: 'barber'),
                      decoration: decoration('Role'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: barberName),
                      decoration: decoration('Branch'),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Barber details not found.'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
}
