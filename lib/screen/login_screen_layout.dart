import 'package:cvproject_flutter/resources/auth_methos.dart';
import 'package:cvproject_flutter/responsive/mobile_screen_layout.dart';
import 'package:cvproject_flutter/responsive/responsive_layout_screen.dart';
import 'package:cvproject_flutter/responsive/web_screen_layout.dart';
import 'package:cvproject_flutter/screen/home_page.dart';
import 'package:cvproject_flutter/screen/signup_screen_layout.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreenLayout extends StatefulWidget {
  const LoginScreenLayout({super.key});

  @override
  State<LoginScreenLayout> createState() => _LoginScreenLayoutState();
}

class _LoginScreenLayoutState extends State<LoginScreenLayout> {
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passcontroller = new TextEditingController();
  bool _pass = true;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passcontroller.dispose();
  }

  LoginUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUser(
      maill: _emailcontroller.text,
      pass: _passcontroller.text,
    );
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
          child: Stack(
        children: [
          // Image.asset(
          //   'assets/images/siunhanchibi.jpg', // Đường dẫn đến hình ảnh của bạn
          //   fit: BoxFit.cover, // Đảm bảo hình ảnh phủ toàn bộ màn hình
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              // color: Colors.deepPurpleAccent,
              padding: EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    child: Container(
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
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
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 20),
                                ),
                        )),
                    onTap: () {
                      LoginUpUser();
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
                        child: Text("Don't have an account?"),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreenLayout()),
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
          ),
        ],
      )),
    );
  }
}
