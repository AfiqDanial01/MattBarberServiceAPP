//return a formatted data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String FormatDate(Timestamp timestamp) {
  //Timestamp is the object we retrieve from firebase
  //so to dispplay it, lets convert it to a string

  DateTime dateTime = timestamp.toDate();

  //getyear
  String year = dateTime.year.toString();

  //getmonth
  String month = dateTime.month.toString();

  //getday
  String day = dateTime.day.toString();

  //final formatted date
  String formattedData = '$day/$month/$year';

  return formattedData;
}
