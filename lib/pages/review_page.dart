import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/review_post.dart';
import '../helper/helper_methods.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Uploaded Review'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Review")
            .where('UserEmail', isEqualTo: currentUser?.email)
            .orderBy("TimeStamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data!.docs;

            if (reviews.isEmpty) {
              return Center(
                child: Text('You havent left a review yet.'),
              );
            }

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewPost(
                  message: review['Message'],
                  user: review['UserEmail'],
                  reviewId: review.id,
                  likes: List<String>.from(review['Likes'] ?? []),
                  time: FormatDate(review['TimeStamp']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
