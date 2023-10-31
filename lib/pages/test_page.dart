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

class TestPage extends StatefulWidget {
  TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 2;

  //final screens =[
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30),
      Icon(Icons.people_rounded, size: 30),
      Icon(Icons.shop_2_rounded, size: 30),
      Icon(Icons.book_online_rounded, size: 30),
      Icon(Icons.message_outlined, size: 30),
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
                      builder: (context) => TestPage(),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarbershopPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowBookingPage(),
                    ),
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(),
                    ),
                  );
                } else if (index == 5) {}
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
                  builder: (context) => const ProfilePage(),
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
                  builder: (context) => const BarbershopPage(),
                ));
              },
            ),
            ListTile(
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
            ),
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
