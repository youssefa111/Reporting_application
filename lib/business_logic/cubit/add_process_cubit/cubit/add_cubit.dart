import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_task/model/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit() : super(AddInitial());

  static AddCubit get(BuildContext context) => BlocProvider.of(context);

  List homePostsList = [];

  Future<void> addReport({
    required ReportModel reportModel,
  }) async {
    emit(AddReportLoading());
    FirebaseFirestore.instance
        .collection("posts")
        .add(reportModel.toMap())
        .then((value) {
      emit(AddReportSucessfully());
    }).catchError((error) {
      emit(AddReportError());
    });
  }

  // ignore: avoid_init_to_null
  File? image = null;
  List imagesList = [];
  final picker = ImagePicker();
  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ImageAddedSucessfully());
      imagesList.add(image);
    } else {
      print('No image selected.');
    }
  }

  void removeImage(int index) {
    imagesList.removeAt(index);
    emit(ImageRemovedSucessfully());
  }

  Future<dynamic> getUserData() async {
    var userID = FirebaseAuth.instance.currentUser!.uid;
    var userInfo =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    return userInfo;
  }
}