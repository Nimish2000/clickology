import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chats_json.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clickology/screens/chat_screen.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  _welcomeScreenState createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  final _firestore = FirebaseFirestore.instance;

  Widget userInfo(String userName, String userEmail) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userEmail: userEmail,
                    ),
                  ),
                );
              },
              padding: EdgeInsets.only(right: 4.0),
              child: Row(
                children: [
                  Container(
                    height: 70.0,
                    width: 70.0,
                    child: Stack(
                      children: [
                        Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                userMessages[0]['img'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        userMessages[0]['online']
                            ? Positioned(
                                top: 48.0,
                                left: 52.0,
                                child: Container(
                                  height: 20.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 135.0,
                        child: Text(
                          userMessages[0]['message'] +
                              " - " +
                              userMessages[0]['created_at'],
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black.withOpacity(0.8),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('⚡️ Chat'),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something Went Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final messages = snapshot.data!.docs;
              List<Widget> userDetails = [];
              for (var userData in messages) {
                final userName = userData['user_name'];
                final userEmail = userData['user_email'];
                final userInfoWidget = userInfo(userName, userEmail);
                userDetails.add(userInfoWidget);
              }
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 20.0),
                children: userDetails,
              );
            }),
      ),
    );
  }
}
