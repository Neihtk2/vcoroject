import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/users.dart' as model;
import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      // body: Center(
      //     child: Text(
      //   user.username,
      //   style: TextStyle(color: Colors.white),
      // )),
      body: PageView(
        children: [
          Center(child: listpage.elementAt(0)),
          Center(child: listpage.elementAt(1)),
          Center(child: listpage.elementAt(2)),
          Center(child: listpage.elementAt(3)),
        ],
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        // onPageChanged: _selectpage,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: _page == 1 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _page == 3 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
          ],
          elevation: 5,
          onTap: (index) {
            // Chuyển đến trang tương ứng
            _pageController.jumpToPage(index);
            _selectpage(index);
          }),
    );
  }

  // void getUsername() async {
  //   var snap = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }

  void _selectpage(int page) {
    setState(() {
      _page = page;
    });
  }
}
