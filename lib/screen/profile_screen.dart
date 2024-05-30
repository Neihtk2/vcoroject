// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/resources/auth_methos.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/screen/login_screen_layout.dart';
import 'package:cvproject_flutter/utils/list_images.dart';
import 'package:cvproject_flutter/utils/list_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cvproject_flutter/mutel/users.dart' as model;
import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/column_profile.dart';
import 'package:cvproject_flutter/utils/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  late String uid;
  ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late model.User user;
  int postLen = 0;
  late bool isFollow;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getPost();
  }

  getPost() async {
    var postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();
    isFollow =
        await user.followers.contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      postLen = postSnap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          centerTitle: false,
          backgroundColor: mobileBackgroundColor,
          actions: [widget.uid == _user.uid ? OverlayList() : SizedBox()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 10),
              //       child: Text(user.username),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 10),
              //       child: OverlayList(),
              //     )
              //   ],
              // ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ColumnProfile(number: postLen, title: 'Posts'),
                            ColumnProfile(
                                number: user.followers.length,
                                title: 'Followers'),
                            ColumnProfile(
                                number: user.following.length,
                                title: 'Followings')
                          ],
                        ),
                        widget.uid == _user.uid
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FollowButton(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    backgroundcolor: mobileBackgroundColor,
                                    bordercolor: Colors.grey,
                                    text: 'Sign Out',
                                    textcolor: Colors.white,
                                    function: () async {
                                      await AuthMethods().signOut();
                                      // FirebaseAuth.instance.signOut();
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreenLayout(),
                                      ));
                                      getData();
                                    },
                                  )
                                ],
                              )
                            : isFollow
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FollowButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        backgroundcolor: Colors.grey,
                                        bordercolor: Colors.grey,
                                        text: 'UnFollow',
                                        textcolor: Colors.white,
                                        function: () async {
                                          await FirestoreMethods().follower(
                                              uid: user.uid,
                                              folower: user.followers,
                                              followId: _user.uid);
                                          await FirestoreMethods().following(
                                              uid: user.uid,
                                              folowing: _user.following,
                                              followId: _user.uid);
                                          setState(() {
                                            isFollow = false;
                                            getData();
                                          });
                                        },
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FollowButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        backgroundcolor: Colors.blue,
                                        bordercolor: Colors.blue,
                                        text: 'Follow',
                                        textcolor: Colors.white,
                                        function: () async {
                                          await FirestoreMethods().follower(
                                              uid: user.uid,
                                              folower: user.followers,
                                              followId: _user.uid);
                                          await FirestoreMethods().following(
                                              uid: user.uid,
                                              folowing: _user.following,
                                              followId: _user.uid);
                                          setState(() {
                                            isFollow = true;
                                            getData();
                                          });
                                        },
                                      )
                                    ],
                                  )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  user.username,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(
                  user.bio,
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListImages(uid: widget.uid)
            ],
          ),
        )
        // Container(
        //   padding: EdgeInsets.all(100),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       Container(
        //         child: Column(
        //           children: [
        //             Row(
        //               children: [
        //                 CircleAvatar(
        //                   backgroundImage: NetworkImage(
        //                     _user.photoUrl,
        //                   ),
        //                   radius: 40,
        //                 ),
        //                 Column(
        //                   children: [
        //                     Row(
        //                       children: [
        //                         ColumnProfile(number: 50, title: 'Posts'),
        //                         ColumnProfile(number: 50, title: 'Followers'),
        //                         ColumnProfile(number: 50, title: 'Followings'),
        //                       ],
        //                     ),
        //                     InkWell(
        //                       child: Container(
        //                           decoration: ShapeDecoration(
        //                               shape: RoundedRectangleBorder(
        //                                 borderRadius:
        //                                     BorderRadius.all(Radius.circular(4)),
        //                               ),
        //                               color: Colors.grey),
        //                           width: double.infinity,
        //                           padding: EdgeInsets.symmetric(vertical: 12),
        //                           child: Center(
        //                             child: Text(
        //                               'Edit ProFile',
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 20),
        //                             ),
        //                           )),
        //                       onTap: () {},
        //                     ),
        //                   ],
        //                 )
        //               ],
        //             )
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }

  Future<model.User> getData() async {
    var snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();
    setState(() {
      // var a = snap.data();
      user = model.User.fromSnap(snap);
    });

    return user;
  }
}
