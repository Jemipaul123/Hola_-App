
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hola_app/components/String_helper.dart';
import 'package:hola_app/components/comment_button.dart';
import 'package:hola_app/components/delete_button.dart';
import 'like_button.dart';
import 'comment.dart';

class WallPost extends StatefulWidget {

  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;


  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.time,
    required this.likes,


});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser =FirebaseAuth.instance.currentUser!;
  bool isLiked =false;

  //comment text controller

  final _commentTextController =TextEditingController();
  @override
 void initState(){
    super.initState();
    isLiked =widget.likes.contains(currentUser.email);
  }
  void toggleLike(){
    setState(() {
      isLiked =!isLiked;
    });

    DocumentReference postRef =
    FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked)
    {
      postRef.update({
        'Likes':FieldValue.arrayUnion([currentUser.email])
      });
    }
    else {
      postRef.update({
        'Likes':FieldValue.arrayRemove([currentUser.email])
      });
    }
  }
  //add a comment
  void addComment(String commentText){
    FirebaseFirestore.instance.collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText" : commentText,
      "CommentedBy" : currentUser.email,
      "CommentTime" : DateTime.timestamp(),
    });
  }

  void showCommentDialog(){
    showDialog(context: context, builder: (context) =>AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: _commentTextController ,
        decoration: InputDecoration(hintText: "Write a comment")

      ),
     actions: [
     TextButton(onPressed: () { addComment(_commentTextController.text);
       //clear controller
       _commentTextController.clear();

       //pop box
       Navigator.pop(context);
       },
    child:Text("Post"),
    ),

         TextButton(onPressed: () {
           Navigator.pop(context);
           },
         child:Text("Cancel"),
       ),
     ],
    ),

    );
  }
  //delete button
  void deletepost()
  {
    showDialog(
      context: context,
      builder: (context) =>AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure?"),
        actions:
          [
            TextButton(onPressed: () =>Navigator.pop(context),
                child: const Text("Cancel"),
            ),
            TextButton(onPressed:() async {
             // first delete comments
              final commentDocs =await FirebaseFirestore.instance.collection("User Posts")
             .doc(widget.postId)
             .collection("Comments")
             .get();
              for(var doc in commentDocs.docs)
                {
                  await FirebaseFirestore.instance.collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(doc.id)
                      .delete();
                }

              //then the post
              FirebaseFirestore.instance.collection("User Posts")
                  .doc(widget.postId).delete().then((value) => print("post deleted"))
                  .catchError((error)=>print("failed to delete post:$error"));

            },
              child: const Text("Delete"),
            ),


          ]
      ),
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color:Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        ) ,
        margin: EdgeInsets.only(top: 28, left: 29, right: 25),
        padding: EdgeInsets.all(28),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //buttons
            SizedBox(width: 20),
            Center(
              child: Row(
                children: [
                  Column(children: [
                    SizedBox(width:50),
                    Center(child: Text(widget.message)),
                    const SizedBox(height: 10),
                    SizedBox(width: 5),
                    Row(

                      children: [
                        Text("         ",
                          style: TextStyle(color: Colors.grey[400]) ,),
                        Text(widget.user,
                          style: TextStyle(color: Colors.grey[400]) ,),
                        Text(".",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(height:20),
                        Text(widget.time,
                          style: TextStyle(color: Colors.grey[400]),),
                      ],
                    ),
                    ],
                  ),
                  SizedBox(width: 30,),
                  SizedBox(height: 70,),
                  if(widget.user==currentUser.email)
                    Center(
                      child: DeleteButton(
                          onTap:deletepost),
                    ),
                ],
              ),
            ),
            const SizedBox(width:10),
            const SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //lke button

                Column(
                  children: [
                    LikeButton(isLiked:isLiked,
                      onTap: toggleLike,
                    ),
                    const SizedBox(height:5),
                    Text(widget.likes.length.toString(),
                      style: TextStyle(color: Colors.grey),),
                  ],
                ),
                const SizedBox(width:10),

                Column(
                  children: [
                   CommentButton(
                      onTap: showCommentDialog),
                    //comment count
                    Text(
                      '0',
                      style: const TextStyle(color: Colors.grey)
                    ),
                    const SizedBox(height:5),

                  ],
                ),
              ],
            ),

            //comments display under the post

            StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments").orderBy("CommentTime",descending: true).snapshots(), builder: (context,snapshot)
            {
                   if(!snapshot.hasData)
                     {
                       return const Center(
                         child: CircularProgressIndicator(),
                       );
                     }
                   return ListView(
                     shrinkWrap: true, //for nested lists
                     physics: const NeverScrollableScrollPhysics(),
                     children: snapshot.data!.docs.map((doc){
            final commentData =doc.data() as Map<String,dynamic>;

            //return the comment
            return Comment(
                text: commentData["CommentText"],
            user: commentData["CommentedBy"],

            time: formatDate(commentData["CommentTime"]));
            //get the comment
                     }).toList(),
                   );
            })


          ]
        ),
      ),
    );
  }
}
