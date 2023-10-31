import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mattbarber_app/components/my_textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mattbarber_app/components/review_post.dart';
import '';
import '../helper/helper_methods.dart';

class BarberReviewPage extends StatefulWidget {
  const BarberReviewPage({Key? key}) : super(key: key);

  @override
  State<BarberReviewPage> createState() => _BarberReviewPageState();
}

class _BarberReviewPageState extends State<BarberReviewPage> {
  //
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text Controller
  final textController = TextEditingController();

  //post Review
  void postReview() {
    //only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("Review").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: const Text('Customer Review'),
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: Column(children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Review")
                .orderBy("TimeStamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the review
                    final post = snapshot.data!.docs[index];
                    return ReviewPost(
                      message: post['Message'],
                      user: post['UserEmail'],
                      reviewId: post.id,
                      likes: List<String>.from(post['Likes'] ?? []),
                      time: FormatDate(post['TimeStamp']),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:' + snapshot.error.toString()),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            children: [
              //textfield
              Expanded(
                child: MyTextField(
                  controller: textController,
                  hintText: "Leave a Review",
                  obscureText: false,
                ),
              ),

              //post button
              IconButton(
                  iconSize: 40,
                  onPressed: postReview,
                  icon: const Icon(Icons.arrow_circle_up)),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ) */
      ])),
    );
  }
}
