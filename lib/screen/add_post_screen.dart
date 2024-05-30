import 'dart:typed_data';

import 'package:cvproject_flutter/mutel/users.dart';
import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _controller = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  _selecImage(BuildContext) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Creat a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from galaxy'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  _selecImage(context);
                },
                icon: Icon(Icons.upload)),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  clearImage();
                },
              ),
              title: Text('Post to'),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {
                      postImage(_user.uid, _user.username, _user.photoUrl);
                      setState(() {
                        _controller.clear();
                      });
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              Divider(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _controller,
                        maxLines: 8,
                        decoration: InputDecoration(
                            hintText: 'Write a caption',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter
                                    // alignment: Alignment.topCenter
                                    )),
                          )),
                    ),
                  ],
                ),
              )
            ]),
          );
  }

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods()
          .uploadPost(_controller.text, _file!, uid, username, profImage);
      if (res == 'succes') {
        setState(() {
          _isLoading = false;
        });
        showSnackbar('Posted!', context);
        clearImage();
      } else
        (showSnackbar(res, context));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }
}
