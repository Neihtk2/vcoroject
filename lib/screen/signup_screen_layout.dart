import 'dart:io';
import 'dart:typed_data';
import 'package:cvproject_flutter/resources/auth_methos.dart';
import 'package:cvproject_flutter/responsive/mobile_screen_layout.dart';
import 'package:cvproject_flutter/responsive/responsive_layout_screen.dart';
import 'package:cvproject_flutter/responsive/web_screen_layout.dart';
import 'package:cvproject_flutter/screen/home_page.dart';
import 'package:cvproject_flutter/screen/login_screen_layout.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreenLayout extends StatefulWidget {
  const SignupScreenLayout({super.key});

  @override
  State<SignupScreenLayout> createState() => _SignupScreenLayoutState();
}

class _SignupScreenLayoutState extends State<SignupScreenLayout> {
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passcontroller = new TextEditingController();
  TextEditingController _biocontroller = new TextEditingController();
  TextEditingController _usernamecontroller = new TextEditingController();
  // var _image = null;
  Uint8List? _image = null;
  bool _pass = true;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passcontroller.dispose();
    _biocontroller.dispose();
    _usernamecontroller.dispose();
  }

  Future<dynamic> pickImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.readAsBytes();
    } else {
      return null;
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage();
    setState(() {
      _image = im;
    });
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        mail: _emailcontroller.text,
        pass: _passcontroller.text,
        name: _usernamecontroller.text,
        bio: _biocontroller.text,
        file: _image);
    print(res);
    setState(() {
      _isLoading = false;
    });
    if (res != 'succes') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    } else
      (Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
                wedScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout())),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
      body: SafeArea(
          child: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: NetworkImage(
        //             'https://www.vietnamworks.com/hrinsider/wp-content/uploads/2023/12/mot-chiec-hinh-nen-vua-dang-yeu-vua-huyen-ao-cho-ban-nu.jpg'),
        //         fit: BoxFit.cover)),
        padding: EdgeInsets.symmetric(horizontal: 32),
        // margin: EdgeInsets.all(40),
        width: double.infinity,
        child: Container(
          // margin: EdgeInsets.all(100),
          // color: Colors.black54,
          padding: EdgeInsets.all(8),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Image(
                image: AssetImage('assets/images/logo_app.png'),
                height: 64,
              ),
              SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(_image!))
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage('assets/images/siunhanchibi.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(Icons.add_a_photo)))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailcontroller,
                decoration: InputDecoration(
                    hintText: 'Mời nhập tên đăng nhập',
                    filled: true,
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    labelText: 'Tên đăng nhập',
                    // labelStyle: TextStyle(fontSize: 5),
                    prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                obscureText: _pass,
                controller: _passcontroller,
                decoration: InputDecoration(
                    hintText: 'Mời nhập mật khẩu',
                    filled: true,
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    labelText: 'Mật khẩu',
                    // labelStyle: TextStyle(fontSize: 5),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_pass
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                      onPressed: () {
                        setState(() {
                          _pass = !_pass;
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _usernamecontroller,
                decoration: InputDecoration(
                    hintText: 'Mời nhập tên người dùng',
                    filled: true,
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    labelText: 'Tên người dùng',
                    // labelStyle: TextStyle(fontSize: 5),
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _biocontroller,
                decoration: InputDecoration(
                    hintText: 'Mời nhập Bio',
                    filled: true,
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    labelText: 'Bio',
                    // labelStyle: TextStyle(fontSize: 5),
                    prefixIcon: Icon(Icons.people)),
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: Colors.blue),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : Text(
                              'SignUp',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 20),
                            ),
                    )),
                onTap: () {
                  signUpUser();
                },
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("You have an account?"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreenLayout()),
                      );
                    },
                  )
                ],
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      )),
    );
  }
}
