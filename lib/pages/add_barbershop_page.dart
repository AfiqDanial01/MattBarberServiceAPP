import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/storage.dart';
import '../models/user.dart';
import 'edit_user_detail_page.dart';

//Page ADMIN add new branch
//Include all details - name, image, caption, etc..

class AddBarbershopPage extends StatefulWidget {
  const AddBarbershopPage({Key? key}) : super(key: key);

  @override
  _AddBarbershopPageState createState() => _AddBarbershopPageState();
}

class _AddBarbershopPageState extends State<AddBarbershopPage> {
  Map<String, dynamic> dataMap = {};
  List<String> dropdownValues = [];
  List<String> dropdownIdValues = [];
  String selectedBarber = '';
  final formKey = GlobalKey<FormState>();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _branchAddressController =
      TextEditingController();
  final TextEditingController _branchOpHourController = TextEditingController();
  final TextEditingController _branchPhoneNoController =
      TextEditingController();

  bool isLoading = true;
  bool hasImage = false;
  bool barberIsAvailable = true;
  String downloadUrl = "";
  File? announcementImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    Map<String, dynamic> dataMap = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Account")
          .where("role", isEqualTo: "barber")
          .where("isEmployed", isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          dataMap[element.id] = data;
          dropdownValues.add(data['name']);
        });
        setState(() {
          dropdownIdValues = dataMap.keys.toList();
          selectedBarber = dropdownValues[0];
          isLoading = false;
        });
      } else {
        barberIsAvailable = false;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _branchNameController.dispose();
    _branchAddressController.dispose();
    _branchOpHourController.dispose();
    _branchPhoneNoController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Storage storage = Storage();
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Barbershop Details'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : barberIsAvailable
                ? Form(
                    key: formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        hasImage == true
                            ? Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 0.8,
                                        style: BorderStyle.solid),
                                    image: DecorationImage(
                                        image: Image.file(
                                                File(announcementImage!.path))
                                            .image,
                                        fit: BoxFit.cover)),
                              )
                            : const SizedBox(),
                        InkWell(
                          onTap: () async {
                            final results = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg']);

                            if (results == null) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No file selected")));
                            } else {
                              final path = results.files.single.path!;
                              final fileName = results.files.single.name;

                              setState(() {
                                announcementImage = File(path);
                                hasImage = true;
                              });

                              storage.uploadFile(path, fileName).then(
                                  (value) async => downloadUrl =
                                      await storage.downloadURL(fileName));

                              print(downloadUrl);
                            }
                          },
                          child: Container(
                            height: size.height / 15.0,
                            width: size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 0.8,
                                    style: BorderStyle.solid)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  hasImage == false
                                      ? const Text(
                                          "Add Picture",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          "Change Picture",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                ]),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _branchNameController,
                          decoration: decoration('Enter branch name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _branchAddressController,
                          decoration: decoration('Enter branch address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _branchOpHourController,
                          decoration: decoration('Enter branch operation hour'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _branchPhoneNoController,
                          decoration: decoration('Enter branch phone number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: DropdownButton<String>(
                              value: selectedBarber,
                              items: dropdownValues
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBarber = value!;
                                });
                              }),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          child: Text('Add Branch Details'),
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                hasImage == true) {
                              save();
                            }

                            if (hasImage == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Image is needed")));
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : const Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Text(
                          "No available barber. Barbershop details cannot be added right now"),
                    ),
                  ));
  }

  void save() async {
    if (hasImage == true && downloadUrl == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed image upload'),
            content: Text('Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      final String branchId = const Uuid().v4();

      String selectedBarberUid =
          dropdownIdValues.elementAt(dropdownValues.indexOf(selectedBarber));

      var data = {
        "branchId": branchId,
        "branch": _branchNameController.text,
        "address": _branchAddressController.text,
        "opHour": _branchOpHourController.text,
        "phoneNo": _branchPhoneNoController.text,
        "branchPhoto": downloadUrl,
        "barber": selectedBarber,
        "barberUid": selectedBarberUid
      };

      await FirebaseFirestore.instance
          .collection("Account")
          .doc(selectedBarberUid)
          .update({'isEmployed': "true"});

      await FirebaseFirestore.instance
          .collection("barbershop")
          .doc(branchId)
          .set(data);

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
