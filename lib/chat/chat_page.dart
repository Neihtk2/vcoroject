// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/chat/chat_bubble.dart';
import 'package:cvproject_flutter/chat/chat_services.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class ChatPage extends StatefulWidget {
  final String recceiverUserId;
  final String recceiverUserEmail;
  const ChatPage({
    Key? key,
    required this.recceiverUserId,
    required this.recceiverUserEmail,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messagecontroller = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void sendMessager() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.recceiverUserId, _messagecontroller.text);
      setState(() {
        _messagecontroller.clear();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messagecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> ids = [
      widget.recceiverUserId,
      FirebaseAuth.instance.currentUser!.uid,
    ];
    ids.sort();
    String chatRoomId = ids.join("_");
    _deleteMess(BuildContext) {
      return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              // contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              children: [
                SimpleDialogOption(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text('Delete Message'),
                  onPressed: () async {
                    await _chatServices.deleteMessage(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.recceiverUserId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recceiverUserEmail),
        actions: [
          IconButton(
              onPressed: () {
                _deleteMess(BuildContext);
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatServices.getMessanges(
            FirebaseAuth.instance.currentUser!.uid, widget.recceiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // var b = _chatServices.getMessanges(
          //     FirebaseAuth.instance.currentUser!.uid, widget.recceiverUserId);
          // var a = snapshot.data.docs[1];
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => _buildMessageItem(
                    (snapshot.data! as dynamic).docs[index],
                  ));
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    var data = document.data() as Map<String, dynamic>;
    var alignment =
        (data['senderId'] == FirebaseAuth.instance.currentUser!.uid);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      alignment: alignment ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            alignment ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          SizedBox(
            height: 5,
          ),
          ChatBubble(
            mess: data['messege'],
            isUser: alignment,
          )
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextField(
            controller: _messagecontroller,
            decoration: InputDecoration(
              hintText: 'Enter Message',
            ),
            obscureText: false,
          ),
        )),
        IconButton(
            onPressed: () {
              sendMessager();
            },
            icon: Icon(
              Icons.arrow_upward,
              size: 40,
            ))
      ],
    );
  }
}
