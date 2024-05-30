import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/screen/add_post_screen.dart';
import 'package:cvproject_flutter/screen/home_page.dart';
import 'package:cvproject_flutter/screen/profile_screen.dart';
import 'package:cvproject_flutter/screen/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<Widget> listpage = [
  HomePage(),
  SearchScreen(),
  AddPost(),

  // Text('Favourite Page',
  //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
