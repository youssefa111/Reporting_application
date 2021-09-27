import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../business_logic/cubit/homescreen_cubit/home_screen_cubit.dart';

// ignore: must_be_immutable
class ReplySection extends StatefulWidget {
  final String postKey;
  List? commentList;
  ReplySection({
    Key? key,
    required this.postKey,
    this.commentList,
  }) : super(key: key);

  @override
  _ReplySectionState createState() => _ReplySectionState();
}

class _ReplySectionState extends State<ReplySection> {
  var commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postKey)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Wrap(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a Reply...',
                            hintStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                              gapPadding: 12,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          commentController.text.trim().isEmpty
                              // ignore: unnecessary_statements
                              ? null
                              : HomeScreenCubit.get(context)
                                  .reply(widget.postKey, commentController.text)
                                  .then((value) => commentController.clear());
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.commentList == null
                  ? Center(
                      child: Text(
                      'There is no reply yet!',
                      style: TextStyle(fontSize: 11),
                    ))
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.commentList![index]
                                            .split(':')[0]
                                            .toString()[0],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 7,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.commentList![index].split(':')[0],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.commentList![index].split(':')[1],
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemCount: widget.commentList!.length,
                    ),
            ],
          );
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        List? x = data['replyList']?.values.toList();
        return Wrap(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a Reply...',
                          hintStyle: TextStyle(fontSize: 11),
                          border: OutlineInputBorder(
                            gapPadding: 12,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        commentController.text.trim().isEmpty
                            // ignore: unnecessary_statements
                            ? null
                            : HomeScreenCubit.get(context)
                                .reply(widget.postKey, commentController.text)
                                .then((value) => commentController.clear());
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            x == null
                ? Center(
                    child: Text(
                    'There is no reply yet!',
                    style: TextStyle(fontSize: 11),
                  ))
                : ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ClipRRect(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      x[index].split(':')[0].toString()[0],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  x[index].split(':')[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              x[index].split(':')[1],
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemCount: x.length,
                  ),
          ],
        );
      },
    );
  }
}
