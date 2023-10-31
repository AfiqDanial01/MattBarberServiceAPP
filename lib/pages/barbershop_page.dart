import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/pages/add_barbershop_page.dart';
import 'package:mattbarber_app/pages/show_barbershop_details.dart';

class BarbershopPage extends StatefulWidget {
  const BarbershopPage({Key? key}) : super(key: key);

  @override
  State<BarbershopPage> createState() => _BarbershopPageState();
}

class _BarbershopPageState extends State<BarbershopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Matt Barber Branch'),
        backgroundColor: Colors.black,
        /*actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBarbershopPage(),
                ),
              ).then((value) => setState(() {}));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ], */
      ),
      // body: ListView(
      //   children: <Widget>[
      //     _buildBarberTile(
      //       context,
      //       'images/barber1.jpg',
      //       'Branch Marang',
      //       'Caption for Image 1',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber2.jpg',
      //       'Branch Jalan Sultan Sulaiman',
      //       'Caption for Image 2',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber3.jpg',
      //       'Branch Batu Rakit',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber4.jpg',
      //       'Branch Gong Badak',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber5.jpg',
      //       'Branch Kemaman',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber6.jpg',
      //       'Barber Name 3',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber7.jpg',
      //       'Barber Name 3',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),
      //     _buildBarberTile(
      //       context,
      //       'images/barber8.jpg',
      //       'Barber Name 3',
      //       'Caption for Image 3',
      //       'Click for more details',
      //     ),

      //     // Add more tiles as needed
      //   ],
      // ),

      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("barbershop").get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Map data = snapshot.data?.docs[index].data() as Map;

                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: _buildBarberTile(
                          context,
                          data['branchPhoto'].toString(),
                          data['branch'],
                          data['opHour'],
                          'Click for more details',
                          data),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _buildBarberTile(BuildContext context, String imagePath,
      String barberName, String caption, String text, Map data) {
    return InkWell(
      onTap: () {
        // Handle image click event
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowBarbershopDetails(data: data),
          ),
        ).then((value) => setState(() {}));
      },
      child: ListTile(
        // leading: Image.asset(
        //   imagePath,
        //   width: 80.0,
        //   height: 80.0,
        //   fit: BoxFit.cover,
        // ),
        leading: Image(
          image: CachedNetworkImageProvider(imagePath),
          width: 100.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
        title: Text(
          barberName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              caption,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 20.0),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
