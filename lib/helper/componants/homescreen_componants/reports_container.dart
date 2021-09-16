import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_task/helper/componants/homescreen_componants/comment_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';

import '../../../business_logic/cubit/homescreen_cubit/home_screen_cubit.dart';
import '../../../model/report_model.dart';

// ignore: must_be_immutable
class NewReportContainer extends StatefulWidget {
  final ReportModel model;
  final String reportID;

  const NewReportContainer(
      {Key? key, required this.model, required this.reportID})
      : super(key: key);

//  widget.key.toString().replaceAll(RegExp('\[<\'>\]'), '').replaceAll(']', '').replaceAll('[', ''),

  @override
  _NewReportContainerState createState() => _NewReportContainerState();
}

class _NewReportContainerState extends State<NewReportContainer> {
  bool showComment = false;
  @override
  Widget build(BuildContext context) {
    var userID = FirebaseAuth.instance.currentUser!.uid;
    return BlocProvider(
      create: (context) => HomeScreenCubit(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.model.reporterLetter,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.model.reporterName,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => OptionsDialog(
                                key: widget.key,
                              ));
                    },
                    icon: Icon(Icons.more_horiz),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FittedBox(
                      child: Text(
                    widget.model.reportName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  Spacer(),
                  Text(
                    widget.model.date,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              widget.model.reportImage != null
                  ? Wrap(
                      runSpacing: 10,
                      spacing: 2,
                      children: widget.model.reportImage!.map((e) {
                        return Container(
                          height: 100,
                          width: e == widget.model.reportImage!.last &&
                                  widget.model.reportImage!.length == 3
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(e), fit: BoxFit.fill),
                          ),
                        );
                      }).toList())
                  : SizedBox(
                      height: 10,
                    ),
              SizedBox(
                height: 10,
              ),
              Text(widget.model.reportContent),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.reportID)
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '( ${widget.model.reportLikes} Agrees , ${widget.model.reportDislikes} Disagrees , ${widget.model.reportComments} Comments )',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          );
                        }
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          '( ${data['reportLikes']} Agrees , ${data['reportDislikes']} Disagrees , ${data['reportComments']} Comments )',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        );
                      }),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 2,
              ),
              StreamBuilder<DocumentSnapshot?>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.reportID)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? FontAwesomeIcons.solidThumbsUp
                                      : FontAwesomeIcons.thumbsUp,
                                  size: 18,
                                );
                              },
                              onTap: (bool x) {
                                return HomeScreenCubit.get(context)
                                    .interactAgree(
                                  widget.key
                                      .toString()
                                      .replaceAll(RegExp('\[<\'>\]'), '')
                                      .replaceAll(']', '')
                                      .replaceAll('[', ''),
                                );
                              },
                              isLiked: widget.model.reactItem == null ||
                                      (widget.model.reactItem != null &&
                                          !widget.model.reactItem
                                              .containsKey(userID))
                                  ? false
                                  : widget.model.reactItem[userID]['isLiked'],
                            ),
                            Text('Agree'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? FontAwesomeIcons.solidThumbsDown
                                      : FontAwesomeIcons.thumbsDown,
                                  size: 18,
                                );
                              },
                              onTap: (bool x) {
                                return HomeScreenCubit.get(context)
                                    .interactDisagree(
                                  widget.key
                                      .toString()
                                      .replaceAll(RegExp('\[<\'>\]'), '')
                                      .replaceAll(']', '')
                                      .replaceAll('[', ''),
                                );
                              },
                              isLiked: widget.model.reactItem == null ||
                                      (widget.model.reactItem != null &&
                                          !widget.model.reactItem
                                              .containsKey(userID))
                                  ? false
                                  : widget.model.reactItem[userID]
                                      ['isDisliked'],
                            ),
                            Text('Disagree'),
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.comment,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Comment'),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () => HomeScreenCubit.get(context)
                            .interactAgree(widget.reportID),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  data['reactItem'] != null &&
                                          data['reactItem']
                                              .containsKey(userID) &&
                                          data['reactItem'][userID]['isLiked']
                                      ? FontAwesomeIcons.solidThumbsUp
                                      : FontAwesomeIcons.thumbsUp,
                                  color: data['reactItem'] != null &&
                                          data['reactItem']
                                              .containsKey(userID) &&
                                          data['reactItem'][userID]['isLiked']
                                      ? Colors.green
                                      : Colors.black,
                                  size: 18,
                                );
                              },
                              onTap: (bool x) {
                                return HomeScreenCubit.get(context)
                                    .interactAgree(widget.reportID);
                              },
                              isLiked: data['reactItem'] != null &&
                                      data['reactItem'].containsKey(userID)
                                  ? data['reactItem'][userID]['isLiked']
                                  : false,
                            ),
                            Text('Agree'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => HomeScreenCubit.get(context)
                            .interactDisagree(widget.reportID),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  data['reactItem'] != null &&
                                          data['reactItem']
                                              .containsKey(userID) &&
                                          data['reactItem'][userID]
                                              ['isDisliked']
                                      ? FontAwesomeIcons.solidThumbsDown
                                      : FontAwesomeIcons.thumbsDown,
                                  color: data['reactItem'] != null &&
                                          data['reactItem']
                                              .containsKey(userID) &&
                                          data['reactItem'][userID]
                                              ['isDisliked']
                                      ? Colors.red[900]
                                      : Colors.black,
                                  size: 18,
                                );
                              },
                              onTap: (bool x) {
                                return HomeScreenCubit.get(context)
                                    .interactDisagree(widget.reportID);
                              },
                              isLiked: data['reactItem'] != null &&
                                      data['reactItem'].containsKey(userID)
                                  ? data['reactItem'][userID]['isDisliked']
                                  : false,
                            ),
                            Text('Disagree'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showComment = !showComment;
                          });
                        },
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.comment,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Comment'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (showComment) CommentSection(postKey: widget.reportID),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({Key? key}) : super(key: key);

  @override
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  int? group = 0;
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width * .2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15.0),
                  //   child: InteractButton(
                  //       icon: FontAwesomeIcons.share, iconName: 'Share'),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: InteractButton(
                        func: () => HomeScreenCubit.get(context)
                            .hidePost(widget.key.toString(), context),
                        icon: FontAwesomeIcons.eyeSlash,
                        iconName: 'Hide post'),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15.0),
                  //   child: InteractButton(
                  //       icon: FontAwesomeIcons.flag, iconName: 'Report post'),
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Radio<int>(
                  //       value: 1,
                  //       groupValue: group,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           group = value;
                  //         });
                  //       },
                  //     ),
                  //     Text('Inappropraite'),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Radio<int>(
                  //       value: 2,
                  //       groupValue: group,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           group = value;
                  //         });
                  //       },
                  //     ),
                  //     Text('Inappropraite'),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Radio<int>(
                  //       value: 3,
                  //       groupValue: group,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           group = value;
                  //         });
                  //       },
                  //     ),
                  //     Text('Privacy concernt'),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Radio<int>(
                  //       value: 4,
                  //       groupValue: group,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           group = value;
                  //         });
                  //       },
                  //     ),
                  //     Text('Commercial solicitiation'),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Radio<int>(
                  //       value: 5,
                  //       groupValue: group,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           group = value;
                  //         });
                  //       },
                  //     ),
                  //     Text('False report'),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {},
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class InteractBar extends StatelessWidget {
//   const InteractBar({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeScreenCubit, HomeScreenState>(
//       builder: (context, state) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             InteractButton(
//                 func: () => HomeScreenCubit.get(context).interactAgree(
//                       key
//                           .toString()
//                           .replaceAll(RegExp('\[<\'>\]'), '')
//                           .replaceAll(']', '')
//                           .replaceAll('[', ''),
//                     ),
//                 icon: HomeScreenCubit.get(context).agreedIcon,
//                 iconName: 'Agree'),
//             InteractButton(
//                 func: () => HomeScreenCubit.get(context).interactDisagree(
//                       key
//                           .toString()
//                           .replaceAll(RegExp('\[<\'>\]'), '')
//                           .replaceAll(']', '')
//                           .replaceAll('[', ''),
//                     ),
//                 icon: HomeScreenCubit.get(context).disagreedIcon,
//                 iconName: 'Disagree'),
//             InteractButton(icon: FontAwesomeIcons.comment, iconName: 'Comment'),
//           ],
//         );
//       },
//     );
//   }
// }

class InteractButton extends StatelessWidget {
  final IconData icon;
  final String iconName;
  final VoidCallback? func;

  const InteractButton({
    Key? key,
    required this.icon,
    this.func,
    required this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (InkWell(
      onTap: () => func!(),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FaIcon(
              icon,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(iconName)
          ],
        ),
      ),
    ));
  }
}
