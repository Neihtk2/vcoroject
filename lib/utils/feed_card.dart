import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/users.dart';

import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/screen/comment_screen.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/like_animation.dart';
import 'package:cvproject_flutter/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedsCard extends StatefulWidget {
  final snap;
  const FeedsCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<FeedsCard> createState() => _FeedsCardState();
}

class _FeedsCardState extends State<FeedsCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<UserProvider>(context).getUser;
    _selecPost(BuildContext) {
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
                  child: Text('Delete'),
                  onPressed: () {
                    if (_user.uid == widget.snap['uid']) {
                      FirestoreMethods().deletePost(
                        widget.snap['postId'],
                      );
                    } else {
                      showSnackbar(
                          'You are not authorized to delete this post.',
                          context);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                  radius: 16,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                IconButton(
                    onPressed: () {
                      _selecPost(BuildContext);
                    },
                    icon: Icon(Icons.more_vert))
              ]),
            ),
            Container(
              child: GestureDetector(
                onDoubleTap: () async {
                  await FirestoreMethods().likePost(
                      postId: widget.snap['postId'],
                      uid: _user.uid,
                      like: widget.snap['likes']);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child:
                          // Image(
                          //   image: NetworkImage(_user.photoUrl),
                          //   fit: BoxFit
                          //       .cover, // Tùy chọn: Kiểm soát cách hình ảnh vừa với container
                          // ),

                          Image.network(widget.snap['postUrl']),
                    ),
                    AnimatedOpacity(
                      opacity: isLikeAnimating ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: LikeAnimation(
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 120,
                        ),
                        isAnimating: isLikeAnimating,
                        duration: Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Transform(
              alignment: Alignment.topLeft, // Điều chỉnh căn chỉnh theo nhu cầu
              transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(_user.uid),
                      smallLike: true,
                      child: IconButton(
                          onPressed: () async {
                            await FirestoreMethods().likePost(
                                postId: widget.snap['postId'],
                                uid: _user.uid,
                                like: widget.snap['likes']);
                          },
                          icon:
                              widget.snap['likes'].contains(_user.uid) == false
                                  ? Icon(Icons.favorite_border)
                                  : Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              snap: widget.snap['postId'],
                            ),
                          ));
                        },
                        icon: Icon(
                          Icons.comment_outlined,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                        )),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bookmark_border,
                          )),
                    )),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text('${widget.snap['likes'].length} Likes',
                      style: Theme.of(context).textTheme.bodyMedium)),
            ),
            Container(
              padding: EdgeInsets.only(top: 8),
              width: double.infinity,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                    TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: '  ${widget.snap['description']}',
                    )
                  ])),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'View all 200 comments',
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              onTap: () {},
            ),
            Container(
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd().format(
                      (widget.snap['datePublished'] as Timestamp).toDate()),
                  style: TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
            )
          ]),
    );
  }
}
