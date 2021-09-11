import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_task/business_logic/cubit/add_process_cubit/cubit/add_cubit.dart';
import 'package:first_task/model/report_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  final IconData iconData;
  final String reportCategoryName;

  ReportScreen(
      {Key? key, required this.iconData, required this.reportCategoryName})
      : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var reportTextEditing = TextEditingController();
  var userInfo;
  var userID;

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void dispose() {
    reportTextEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d ABBR_MONTH').format(now);
    return BlocProvider(
      create: (context) => AddCubit(),
      child: BlocConsumer<AddCubit, AddState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  AddCubit.get(context).imagesList = [];
                  AddCubit.get(context).image = null;
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text('Report an issue'),
              actions: [
                TextButton(
                  onPressed: () {
                    reportTextEditing.text.isEmpty
                        // ignore: unnecessary_statements
                        ? null
                        : AddCubit.get(context)
                            .addReport(
                              reportModel: ReportModel(
                                  reportDate: formattedDate,
                                  reporterName: userInfo['name'],
                                  reportContent: reportTextEditing.text,
                                  reportImage: AddCubit.get(context).imagesList,
                                  reportName: widget.reportCategoryName,
                                  reportLocation: userInfo['neighborhood'],
                                  reporterLetter:
                                      userInfo['name'].toString()[0],
                                  reportComments: 0,
                                  reportDislikes: 0,
                                  reportLikes: 0,
                                  userID: userID,
                                  containerCategory: 1),
                            )
                            .then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content:
                                      Text('The Report is added Sucessfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            )
                            .then((value) {
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    userInfo = data;
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'For Emergencies Call 911',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(widget.iconData),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  widget.reportCategoryName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: reportTextEditing,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText: 'Enter Issue Description...',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Incident Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text(data['neighborhood']),
                                Spacer(),
                                IconButton(
                                  iconSize: 45,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_right,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BlocBuilder<AddCubit, AddState>(
                                builder: (context, state) {
                              var bloc = AddCubit.get(context);
                              if (bloc.imagesList.isEmpty) {
                                return InkWell(
                                  onTap: bloc.getImageFromGallery,
                                  child: Container(
                                      child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text('Add photos and vidoes'),
                                        ]),
                                  )),
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: bloc.imagesList.map((e) {
                                        if (e == bloc.imagesList.last &&
                                            bloc.imagesList.length < 3) {
                                          return Wrap(
                                            children: <Widget>[
                                              ImageContainer(
                                                e: e,
                                                index:
                                                    bloc.imagesList.indexOf(e),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: bloc
                                                        .getImageFromGallery,
                                                    icon: Icon(Icons.add),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return ImageContainer(
                                          e: e,
                                          index: bloc.imagesList.indexOf(e),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('Something went wrong'));
                  }
                }),
          );
        },
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final e;
  final index;

  const ImageContainer({Key? key, this.e, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCubit, AddState>(
      builder: (context, state) {
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(border: Border.all()),
          child: Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(border: Border.all()),
                child: Image.file(
                  e,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                widthFactor: 0.9,
                child: IconButton(
                  onPressed: () {
                    AddCubit.get(context).removeImage(index);
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.timesCircle,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
