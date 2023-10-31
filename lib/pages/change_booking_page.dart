import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../components/my_button.dart';
import '../models/booking.dart';
import 'package:intl/intl.dart';

class ChangeBookingPage extends StatefulWidget {
  final Bookings? user;
  final Map data;

  const ChangeBookingPage({required this.data, this.user, Key? key})
      : super(key: key);

  @override
  _ChangeBookingPageState createState() => _ChangeBookingPageState();
}

class _ChangeBookingPageState extends State<ChangeBookingPage> {
  int maxBookingsPerDay = 3; // Set the maximum bookings per day to 4
  int maxBookingsPerInterval =
      2; // Maximum bookings allowed per 30-minute interval
  Duration intervalDuration =
      const Duration(minutes: 30); // Duration of each interval
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedBranch;
  List<String> branches = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dateController.text = widget.user?.date ?? '';
    timeController.text = widget.user?.time ?? '';
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('barbershop').get();

    setState(() {
      branches = snapshot.docs.map((doc) => doc['branch'] as String).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> addBookingDetail(Bookings user) async {
    final docUser = FirebaseFirestore.instance
        .collection("Booking")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = user.toJson();
    await docUser.set({
      ...json,
      'branch': selectedBranch, // Add the selected branch to the document data
    });
  }

  Future<bool> checkIfBookingExists(
      String branch, DateTime date, TimeOfDay time) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('branch', isEqualTo: branch)
        .where('date', isEqualTo: date.toString().split(' ')[0])
        .where('time', isEqualTo: time.format(context))
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<int> getBookingsCount(String branch, DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('branch', isEqualTo: branch)
        .where('date', isEqualTo: date.toString().split(' ')[0])
        .get();

    return snapshot.docs.length;
  }

  Future<int> getBookingsCountInInterval(
    String branch,
    DateTime date,
    TimeOfDay time,
  ) async {
    final DateTime startTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final DateTime endTime = startTime.add(intervalDuration);

    final DateFormat formatter = DateFormat('hh:mm a');
    final String formattedStartTime = formatter.format(startTime);
    final String formattedEndTime = formatter.format(endTime);

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('branch', isEqualTo: branch)
        .where('date', isEqualTo: date.toString().split(' ')[0])
        .where('time', isGreaterThanOrEqualTo: formattedStartTime)
        .where('time', isLessThan: formattedEndTime)
        .get();

    return snapshot.docs.length;
  }

  Future<void> showBookingFullDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Full'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Sorry, the booking for the selected time is full.'),
                Text('Please choose a different time.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Bookings? user = widget.user;

    // Use the data as needed
    TextEditingController dateController =
        TextEditingController(text: user?.date ?? '');
    TextEditingController timeController =
        TextEditingController(text: user?.time ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matt Barber Booking'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              DropdownButtonFormField<String>(
                value: selectedBranch,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBranch = newValue;
                  });
                },
                items: branches.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Branch',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: const Text(
                  'Select Date Booking:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(selectedDate != null
                      ? selectedDate!.toString().split(' ')[0]
                      : 'Select a date'),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: const Text(
                  'Select Time Booking:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Select a time'),
                ),
              ),
              const Spacer(),
              MyButton(
                text: 'Book Now',
                onTap: () async {
                  if (selectedDate != null && selectedTime != null) {
                    bool bookingExists = await checkIfBookingExists(
                      selectedBranch!,
                      selectedDate!,
                      selectedTime!,
                    );

                    if (bookingExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "A booking already exists for the selected date and time.",
                          ),
                        ),
                      );
                    } else {
                      int bookingsCount = await getBookingsCount(
                          selectedBranch!, selectedDate!);

                      if (bookingsCount >= maxBookingsPerDay) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Sorry, the booking for today is already full.",
                            ),
                          ),
                        );
                      } else {
                        int bookingsCountInInterval =
                            await getBookingsCountInInterval(
                          selectedBranch!,
                          selectedDate!,
                          selectedTime!,
                        );

                        if (bookingsCountInInterval >= maxBookingsPerInterval) {
                          // Display booking full dialog
                          showBookingFullDialog(context);
                        } else {
                          final detail = Bookings(
                            date: selectedDate!.toString().split(' ')[0],
                            time: selectedTime!.format(context),
                            uid: FirebaseAuth.instance.currentUser!.uid,
                          );

                          try {
                            await addBookingDetail(detail);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Scheduled booking successfully"),
                              ),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            print('Error saving document: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Error scheduling booking. Please try again later.",
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a date and time."),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
