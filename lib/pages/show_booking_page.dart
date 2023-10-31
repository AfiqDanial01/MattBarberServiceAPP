import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/models/booking.dart';
import 'package:mattbarber_app/pages/schedule_booking_page.dart';

import '../components/my_button.dart';

class ShowBookingPage extends StatefulWidget {
  const ShowBookingPage({Key? key}) : super(key: key);

  @override
  State<ShowBookingPage> createState() => _ShowBookingPageState();
}

class _ShowBookingPageState extends State<ShowBookingPage> {
  bool hasUserDetails = true;

  @override
  void initState() {
    super.initState();
    // _getUserData();
  }

  void deleteBookings() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance.collection('Booking').doc(userId).delete();
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Booking'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Booking")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (userData != null) {
                print(userData);

                Bookings user = Bookings(
                  date: userData['date'] ?? 'N/A',
                  time: userData['time'] ?? 'N/A',
                  uid: userData['uid'] ?? 'N/A',
                );

                TextEditingController dateController =
                    TextEditingController(text: user.date);
                TextEditingController timeController =
                    TextEditingController(text: user.time);

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("Account")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            Map<String, dynamic>? accountData =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            if (accountData != null) {
                              String name = accountData['name'] ?? 'N/A';

                              return TextField(
                                enabled: false,
                                controller: TextEditingController(text: name),
                                decoration: decoration('Name'),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: userData['branch']),
                      decoration: decoration('Selected Branch'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: userData['date']),
                      decoration: decoration('Date Booking'),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: userData['time']),
                      decoration: decoration('Time Booking'),
                    ),
                    SizedBox(height: 24),
                    MyButton(
                      text: "Change Booking Schedule",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleBookingPage(
                              user: user,
                              data: {},
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    MyButton(
                      text: "Cancel Bookings",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text(
                                  'Are you sure you want to cancel your bookings?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteBookings(); // Call the deleteBookings function
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                // No booking found for the current user
                return Center(
                  child: Text('Please schedule a booking first'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (hasUserDetails) {
                // Loading case
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // No user details case
                return Center(
                  child: Text('No user details found in the Database table.'),
                );
              }
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            // Reset the flag to recheck if user details exist
            hasUserDetails = true;
          });
        },
      ),
    );
  }
}
