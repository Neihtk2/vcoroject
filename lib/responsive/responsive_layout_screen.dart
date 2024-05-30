import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/utils/dimesions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget wedScreenLayout;
  Widget mobileScreenLayout;
  ResponsiveLayout(
      {super.key,
      required this.wedScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    // await Provider.of<UserProvider>(context).refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: addData(), // Truyền hàm addData làm future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > wedScreenSize) {
              return widget.wedScreenLayout;
            }
            return widget.mobileScreenLayout;
          });
        }
        // var a = snapshot.data;

        // Tùy chọn hiển thị chỉ báo tải trong khi đang lấy dữ liệu
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
