import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowAdminDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Details'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('Account')
            .where('role', isEqualTo: 'admin')
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              QueryDocumentSnapshot<Map<String, dynamic>>? adminDoc =
                  snapshot.data!.docs.isNotEmpty
                      ? snapshot.data!.docs[0]
                      : null;

              if (adminDoc != null) {
                final adminData = adminDoc.data();
                final adminEmail = adminData['email'];
                final adminPassword = adminData['password'];

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Icon(Icons.person, size: 100),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: adminEmail),
                      decoration: decoration('Email'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: adminPassword),
                      decoration: decoration('Password'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: 'admin'),
                      decoration: decoration('Role'),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Admin details not found.'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
}
