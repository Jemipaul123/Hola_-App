import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hola_app/components/Drawer.dart';
import 'package:hola_app/components/post.dart';
import 'profile_page.dart';
import 'package:hola_app/components/String_helper.dart';


import '../components/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController =TextEditingController();
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  void postMessage()
  {if(textController.text.isNotEmpty){
    FirebaseFirestore.instance.collection("User Posts").add({
      'UserEmail': currentUser.email,
      'Message': textController.text,
      'TimeStamp':Timestamp.now(),
      'Likes':[],
    });
  }
  setState(() {
    textController.clear();
  });

  }
  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);
    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          "Hola App",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',

            fontSize: 20,
          ),

        ),

        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(

          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            color: Colors.white,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(

        onProfileTap :goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: StreamBuilder
        (stream: FirebaseFirestore.instance
            .collection("User Posts")
            .orderBy("TimeStamp",
                descending:false,)
                .snapshots(),
              builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
              final post =snapshot.data!.docs[index];
              SizedBox(height:30);
              return Center(
                child: WallPost(

                  message:post['Message'],
                  user: post['UserEmail'],
                  postId: post.id,
                  likes: List<String>.from(post['Likes'] ?? []),
                  time: formatDate(post['TimeStamp']) ,
                ),
              );
            },
            );
          }else if(snapshot.hasError)
            {
              return Center(child: Text('Error:${snapshot.error}'
              ),);
            }
          return const Center(
            child: CircularProgressIndicator(),
          );
              }

                )),

            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child:MyTextField(
                      controller:textController,
                      hintText:'Write something on the wall..',
                      obscureText:false,

                    ),
                  ),
                  IconButton(onPressed: postMessage, icon: Icon(Icons.arrow_upward))
                ],

              ),
            ),



            Text('Logged in as ' +currentUser.email!,style: TextStyle(color: Colors.grey[800]),),
          ],
        ),
      )

    );
  }
}
