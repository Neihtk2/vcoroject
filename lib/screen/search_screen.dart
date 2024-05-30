// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cvproject_flutter/utils/colors.dart';
// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController editingController = TextEditingController();
//   bool isShowUser = false;
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     editingController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Container(
//             height: 40,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 18),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: secondaryColor,
//             ),
//             child: TextField(
//               controller: editingController,
//               decoration: InputDecoration(
//                 hintText: 'Search for a user',
//                 prefixIcon: Icon(Icons.search),
//                 border: InputBorder.none,
//               ),
//               onSubmitted: (String _) {
//                 setState(() {
//                   isShowUser = true;
//                 });
//               },
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: isShowUser
//             ? FutureBuilder(
//                 future: FirebaseFirestore.instance
//                     .collection('user')
//                     .where('username',
//                         isGreaterThanOrEqualTo: editingController.text.trim())
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   return ListView.builder(
//                       itemCount: (snapshot.data! as dynamic).docs.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                             textColor: primaryColor,
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                 (snapshot.data! as dynamic).docs[index]
//                                     ['photoUrl'],
//                               ),
//                             ),
//                             title: Text(
//                               (snapshot.data! as dynamic).docs[index]
//                                   ['username'],
//                             ));
//                       });
//                 })
//             : Text('Post'));
//   }
// }

import 'package:cvproject_flutter/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController editingController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: secondaryColor,
            ),
            child: TextField(
              controller: editingController,
              decoration: InputDecoration(
                hintText: 'Search for a user',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  // Kích hoạt lại biến isShowUser khi người dùng nhập liệu
                  isShowUser = value.isNotEmpty;
                });
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: isShowUser
            ? StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Lọc danh sách người dùng theo tên nhập vào (không phân biệt chữ hoa, chữ thường)
                  var filteredUsers =
                      (snapshot.data! as QuerySnapshot).docs.where((user) {
                    // Lấy tên người dùng từ cơ sở dữ liệu và chuyển đổi thành chữ thường
                    String username = user['username'].toString().toLowerCase();
                    // Chuyển đổi từ khóa tìm kiếm thành chữ thường
                    String keyword = editingController.text.toLowerCase();
                    // So sánh xem tên người dùng có chứa từ khóa tìm kiếm không
                    return username.contains(keyword);
                  }).toList();
                  // Hiển thị danh sách người dùng được lọc
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          (Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: filteredUsers[index]['uid'])),
                          ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(filteredUsers[index]['photoUrl']),
                          ),
                          title: Text(filteredUsers[index]['username']),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('user').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Số cột trong lưới
                      crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                      mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          (Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]['uid'])),
                          ));
                          // Xử lý khi người dùng chọn một gợi ý
                          // Ví dụ: Chuyển đến trang hồ sơ của người dùng
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            snapshot.data!.docs[index]
                                ['photoUrl'], // URL của ảnh người dùng
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                  ;
                },
              ));
  }
}
