import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmEditBarbershopPage extends StatefulWidget {
  Map data;

  ConfirmEditBarbershopPage({required this.data, Key? key}) : super(key: key);

  @override
  _ConfirmEditBarbershopPageState createState() =>
      _ConfirmEditBarbershopPageState();
}

class _ConfirmEditBarbershopPageState extends State<ConfirmEditBarbershopPage> {
  TextEditingController _branchController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _opHourController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  bool _isUpdating = false; // Track if the data is currently being updated
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the existing data
    _branchController.text = widget.data['branch'];
    _addressController.text = widget.data['address'];
    _opHourController.text = widget.data['opHour'];
    _phoneNoController.text = widget.data['phoneNo'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Confirm Edit Barbershop Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _branchController,
            decoration: InputDecoration(
              labelText: 'Branch',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _opHourController,
            decoration: InputDecoration(
              labelText: 'Opening Hours',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _phoneNoController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child:
                _isUpdating ? CircularProgressIndicator() : Text('Save Edit'),
            onPressed: _isUpdating
                ? null
                : () async {
                    setState(() {
                      _isUpdating = true; // Set the flag to indicate updating
                    });

                    try {
                      await FirebaseFirestore.instance
                          .collection("barbershop")
                          .doc(widget.data['branchId'])
                          .update({
                        "branch": _branchController.text,
                        "address": _addressController.text,
                        "opHour": _opHourController.text,
                        "phoneNo": _phoneNoController.text
                      });

                      // Show a success message using a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Data updated successfully.'),
                        duration: Duration(seconds: 2),
                      ));
                    } catch (e) {
                      // Handle any error that occurred during the update
                      print('Error updating data: $e');
                    }

                    setState(() {
                      _isUpdating = false; // Reset the flag
                    });
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the text controllers when the page is disposed
    _branchController.dispose();
    _addressController.dispose();
    _opHourController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }
}
