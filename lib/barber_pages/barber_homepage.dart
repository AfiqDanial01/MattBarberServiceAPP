import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mattbarber_app/pages/barbershop_page.dart';
import 'package:mattbarber_app/pages/show_barbershop_details.dart';
import 'package:mattbarber_app/pages/show_booking_page.dart';
import 'package:mattbarber_app/pages/profile_page.dart';
import 'package:mattbarber_app/pages/review_page.dart';

import 'barber_barbershop_page.dart';
import 'barber_allbooking_page.dart';
import 'barber_profile_page.dart';
import 'barber_show_barbershop_details.dart';

class BarberHomePage extends StatefulWidget {
  BarberHomePage({super.key});

  @override
  State<BarberHomePage> createState() => _BarberHomePageState();
}

class _BarberHomePageState extends State<BarberHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 1;

  //final screens =[
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30),
      Icon(Icons.people_rounded, size: 30),
      Icon(Icons.book_online_rounded, size: 30),
      Icon(Icons.shop_2_rounded, size: 30),
      /*Icon(Icons.book_online_rounded, size: 30),
      Icon(Icons.message_outlined, size: 30), */
    ];
    return Scaffold(
      //body: screens[index],
      //appbar
      appBar: AppBar(
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("barbershop").get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docLength = snapshot.data?.docs.length ?? 0;
            return ListView.builder(
              itemCount: docLength + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Display the additional container with image
                  return Container(
                    height: 135,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/mmb_test.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  // Display the barber tile using _buildBarberTile function
                  Map data = snapshot.data?.docs[index - 1].data() as Map;
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: _buildBarberTile(
                      context,
                      data['branchPhoto'].toString(),
                      data['branch'],
                      data['opHour'],
                      'Click for more details',
                      data,
                    ),
                  );
                }
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      // body: ListView(
      //   children: <Widget>[
      //     Container(
      //       height: 135,
      //       width: MediaQuery.of(context).size.width,
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           image: AssetImage('images/mmb_test.jpg'),
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber1.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Marang'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber2.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Jalan Sultan Sulaiman'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber3.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Batu Rakit '),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber4.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Gong Badak'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber5.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Kemaman'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber6.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Gong Pak Jin'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber7.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Panji Alam'),
      //       subtitle: Text('See Details'),
      //     ),
      //     ListTile(
      //       leading: Image.asset('images/barber8.jpg', width: 100, height: 100),
      //       title: Text('Cawangan Kuantan'),
      //       subtitle: Text('See Details'),
      //     ),
      //   ],
      // ),
      //backgroundColor: Colors.blue,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
            color: Colors.black,
            backgroundColor: Colors.white,
            //currentIndex:index,
            height: 60,
            index: index,
            items: items,
            onTap: (int tappedIndex) {
              setState(() {
                index = tappedIndex;
                // Perform actions based on the tapped index
                // For example, you can navigate to different pages:
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarberHomePage(),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarberProfilePage(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarberAllBookingPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarberBarbershopPage(),
                    ),
                  );
                } /* else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShowBookingPage(),
                    ),
                  );
                } else if (index == 4) {
                  // Navigate to message page
                } */
              });
            }),
      ),
      drawer: NavigationDrawer(),
      //body: Center(child: Text("WELCOME:) " + user.email!)),
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
            builder: (context) => BarberShowBarbershopDetails(data: data),
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

class NavigationDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  NavigationDrawer({Key? key}) : super(key: key);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );

  Widget buildHeader(BuildContext context) => Container(
      color: Colors.black,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundImage: AssetImage('images/MBbg.png'),
          ),
          const SizedBox(height: 12),
          Text(
            "Welcome: " + user.email!,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ));

  Widget buildMenuItems(BuildContext context) => Container(
        //spacing from side and top

        padding: const EdgeInsets.all(24),
        child: Wrap(
          //space between icon
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Account'),
              onTap: () {
                //back button
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BarberProfilePage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online_rounded),
              title: const Text('Customer Booking'),
              onTap: () {
                //back button
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BarberAllBookingPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop_2_rounded),
              title: const Text('Barbershop'),
              onTap: () {
                //back button
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BarberBarbershopPage(),
                ));
              },
            ),
            /*ListTile(
              leading: const Icon(Icons.book_online_rounded),
              title: const Text('Booking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ShowBookingPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Review'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReviewPage(),
                ));
              },
            ), */
            const Divider(
              color: Colors.black87,
            ),
            ListTile(
              leading: const Icon(Icons.question_mark_outlined),
              title: const Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () {
                signUserOut();
              },
            ),
          ],
        ),
      );
}
