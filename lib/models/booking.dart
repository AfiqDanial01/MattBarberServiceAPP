class Bookings {
  String date;
  String time;
  String uid;

  Bookings({required this.date, required this.time, required this.uid});

  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
        'uid': uid,
      };
}
