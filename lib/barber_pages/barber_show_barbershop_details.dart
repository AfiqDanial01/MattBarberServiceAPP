import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mattbarber_app/pages/schedule_booking_page.dart';

import '../components/my_button.dart';
import '../pages/all_review_page.dart';
import '../pages/edit_barbershop_page.dart';
import 'barber_review_page.dart';

class BarberShowBarbershopDetails extends StatefulWidget {
  final Map data;

  const BarberShowBarbershopDetails({required this.data, Key? key})
      : super(key: key);

  @override
  State<BarberShowBarbershopDetails> createState() =>
      _BarberShowBarbershopDetailsState();
}

class _BarberShowBarbershopDetailsState
    extends State<BarberShowBarbershopDetails> {
  bool hasUserDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matt Barber Branch'),
        backgroundColor: Colors.black,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBarbershopPage(data: widget.data),
                ),
              ).then((value) => setState(() {}));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Image(
                image: CachedNetworkImageProvider(widget.data['branchPhoto']),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 40),
              const Text(
                'Branch:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(widget.data['branch']),
              const SizedBox(height: 16),
              const Text(
                'Address:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(widget.data['address']),
              const SizedBox(height: 20),
              const Text(
                'Opening Hours:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(widget.data['opHour']),
              const SizedBox(height: 20),
              const Text(
                'Phone Number:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(widget.data['phoneNo']),
              const SizedBox(height: 50),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30.0), // Adjust the padding as needed
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(
                    text: "SEE REVIEW",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarberReviewPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
