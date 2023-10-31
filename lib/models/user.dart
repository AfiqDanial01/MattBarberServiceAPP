class Users {
  String name;
  String username;
  String phoneNumber;
  String uid;

  Users(
      {required this.name,
      required this.username,
      required this.phoneNumber,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'phoneNumber': phoneNumber,
        'uid': uid
      };

  static Users fromJson(Map<String, dynamic> map) {
    return Users(
      name: map['name'],
      username: map['username'],
      phoneNumber: map['phoneNumber'],
      uid: map['uid'],
    );
  }
}
