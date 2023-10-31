import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/components/delete_button.dart';
import 'package:mattbarber_app/components/like_button.dart';

import '../helper/helper_methods.dart';
import 'comment.dart';
import 'comment_buton.dart';

class ReviewPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String reviewId;
  final List<String> likes;

  const ReviewPost({
    super.key,
    required this.message,
    required this.user,
    required this.reviewId,
    required this.likes,
    required this.time,
  });

  @override
  State<ReviewPost> createState() => _ReviewPostState();
}

class _ReviewPostState extends State<ReviewPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Review').doc(widget.reviewId);

    if (isLiked) {
      //if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add a comment
  void addComment(String commentText) {
    //write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("Review")
        .doc(widget.reviewId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now() // remember to format this when displaying
    });
  }

  //show dialog box for comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a Comment.."),
        ),
        actions: [
          //cancel button
          TextButton(
            //pop box
            onPressed: () {
              Navigator.pop(context);

              //clear controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),

          //post button
          TextButton(
            onPressed: () {
              //add comment
              addComment(_commentTextController.text);

              //pop box
              Navigator.pop(context);

              //clear controller
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  //delete a review
  void deleteReview() {
    // show a dialog box asking for confirmation before deletion
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Review"),
              content: const Text("Are sure you want to delete this review?"),
              actions: [
                //CANCEL BUTTON
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                //DELETE BUTTON
                TextButton(
                    onPressed: () async {
                      //delete the review from firestore
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("Review")
                          .doc(widget.reviewId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("Review")
                            .doc(widget.reviewId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }

                      //then delete review post
                      FirebaseFirestore.instance
                          .collection("Review")
                          .doc(widget.reviewId)
                          .delete()
                          .then((value) => print("post deleted sucessfully"))
                          .catchError((error) =>
                              print("Failed to delete review: $error"));

                      //dismiss the dialog box
                      Navigator.pop(context);
                    },
                    child: const Text("Delete")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Review Post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //group of text(review _ email)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //User
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      Text(" . ", style: TextStyle(color: Colors.grey[500])),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //review
                  Text(widget.message),
                ],
              ),

              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deleteReview),
            ],
          ),

          const SizedBox(height: 20),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  //like Buttom
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(widget.likes.length.toString()),

                  //Like Count
                ],
              ),

              const SizedBox(width: 10),
              //COMMENT
              Column(
                children: [
                  //comment Buttom
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(height: 5),

                  //Comment Count
                  Text(
                    '0',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          //comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Review")
                .doc(widget.reviewId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle if no data yet
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //FOR NESTED LIST
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return the comment
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: FormatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
