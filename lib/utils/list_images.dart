// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/postclass.dart';
import 'package:cvproject_flutter/mutel/users.dart';
import 'package:flutter/material.dart';

import 'package:cvproject_flutter/screen/profile_screen.dart';
import 'package:cvproject_flutter/utils/colors.dart';

class ListImages extends StatefulWidget {
  late String uid;
  ListImages({
    Key? key,
    required this.uid,
  }) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<ListImages> {
  List<dynamic> listImage = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //  var filteredUsers =
        //               (snapshot.data! as QuerySnapshot).docs.where((user) {
        //             // Lấy tên người dùng từ cơ sở dữ liệu và chuyển đổi thành chữ thường
        //             String username = user['uid'].toString().toLowerCase();
        //             // Chuyển đổi từ khóa tìm kiếm thành chữ thường
        //             String keyword = widget.uid.toLowerCase();
        //
        //             return username.contains(keyword);
        //           }).toList();

        List<Post> filteredUsers = [];
        for (var i = 0; i < (snapshot.data! as dynamic).docs.length; i++) {
          var snap = (snapshot.data! as QuerySnapshot).docs[i];
          Post post = Post.fromSnap(snap);
          if (post.uid == widget.uid) {
            filteredUsers.add(post);
          }
        }
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Số cột trong lưới
            crossAxisSpacing: 5.0, // Khoảng cách giữa các cột
            mainAxisSpacing: 5.0, // Khoảng cách giữa các hàng
          ),
          itemCount: filteredUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  filteredUsers[index].postUrl, // URL của ảnh người dùng
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
        ;
      },
    );
  }
}
