import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/models/booking.dart';
import 'package:mattbarber_app/pages/schedule_booking_page.dart';
import 'package:intl/intl.dart';

class BarberAllBookingPage extends StatefulWidget {
  const BarberAllBookingPage({Key? key}) : super(key: key);

  @override
  State<BarberAllBookingPage> createState() => _BarberAllBookingPageState();
}

class _BarberAllBookingPageState extends State<BarberAllBookingPage> {
  String? barberBranch;

  @override
  void initState() {
    super.initState();
    getBarberBranch();
  }

  void getBarberBranch() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Account')
        .doc(userId)
        .get();
    Map<String, dynamic>? accountData = snapshot.data();
    setState(() {
      barberBranch = accountData?['branch'];
    });
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Account')
        .doc(userId)
        .get();
    return snapshot.data();
  }

  Future<void> deleteBooking(String bookingId) async {
    // Show a confirmation dialog before deleting the booking
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('The booking has been made. Are you sure to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      // Perform the deletion
      await FirebaseFirestore.instance
          .collection('Booking')
          .doc(bookingId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Booking'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Booking')
            .where('branch', isEqualTo: barberBranch)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text('No bookings have been made :('),
            );
          }

          final sortedBookings = snapshot.data!.docs
              .map((booking) =>
                  booking as DocumentSnapshot<Map<String, dynamic>>)
              .toList();

          sortedBookings.sort((a, b) {
            final dateA = a.data()!['date'] as String;
            final timeA = a.data()!['time'] as String;
            final dateB = b.data()!['date'] as String;
            final timeB = b.data()!['time'] as String;

            final dateTimeA =
                DateFormat('yyyy-MM-dd h:mm a').parse('$dateA $timeA');
            final dateTimeB =
                DateFormat('yyyy-MM-dd h:mm a').parse('$dateB $timeB');

            return dateTimeA.compareTo(dateTimeB);
          });

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: sortedBookings.length,
            itemBuilder: (context, index) {
              DocumentSnapshot<Map<String, dynamic>> bookingDoc =
                  sortedBookings[index];
              Map<String, dynamic>? bookingData = bookingDoc.data();
              String bookingId = bookingDoc.id;

              if (bookingData != null) {
                Bookings booking = Bookings(
                  date: bookingData['date'] ?? 'N/A',
                  time: bookingData['time'] ?? 'N/A',
                  uid: bookingData['uid'] ?? 'N/A',
                );

                return Card(
                  child: ListTile(
                    title: Text(
                      'Booking ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Date: ${booking.date}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8), // Added spacing
                        Text(
                          'Time: ${booking.time}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 16), // Added more spacing
                        FutureBuilder<Map<String, dynamic>?>(
                          future: getUserData(booking.uid),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (userSnapshot.hasError) {
                              return Text(
                                'Error: ${userSnapshot.error}',
                                style: TextStyle(fontSize: 14),
                              );
                            }
                            if (!userSnapshot.hasData) {
                              return Text(
                                'User not found',
                                style: TextStyle(fontSize: 14),
                              );
                            }

                            Map<String, dynamic>? userData = userSnapshot.data;

                            if (userData != null) {
                              String userName = userData['name'] ?? 'N/A';
                              String userPhone =
                                  userData['phoneNumber'] ?? 'N/A';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8), // Added spacing
                                  Text(
                                    'Name: $userName',
                                    style: TextStyle(
                                      fontSize: 16, // Increased font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8), // Added spacing
                                  Text(
                                    'Phone: $userPhone',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => deleteBooking(bookingId),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
