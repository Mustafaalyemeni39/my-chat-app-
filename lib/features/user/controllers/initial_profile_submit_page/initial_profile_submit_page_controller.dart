import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';
import 'package:mustafachatclone/features/user/models/user_model.dart';

import '../../../../global/const/app_const.dart';
import '../../../../storage/storage_provider.dart';
import '../../screens/home/home_page.dart';
class InitialProfileSubmitPageController extends GetxController {
  static InitialProfileSubmitPageController get instance => Get.find();

  final usernameController = TextEditingController();
  final RxBool  isProfileUpdating = false.obs;

  final Rx<File>? image = File("").obs;
  // File? image;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImageFromSource(source: ImageSource.gallery);

        if (pickedFile != null) {
          image!.value = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }


    } catch(e) {
      toast("some error occured $e");
    }
  }
  void submitProfileInfo() async{
  if( image!.value.path.isNotEmpty ) {
    print("Creaaaaaaaaaaaaaaaate User info is thre image>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    await StorageProviderRemoteDataSource.uploadProfileImage(
        file: image!.value,
        onComplete: (onProfileUpdateComplete) {
          isProfileUpdating.value = onProfileUpdateComplete;
        }
    ).then((profileImageUrl) async{
       profileInfo(
          profileUrl: profileImageUrl
      );
    });
  } else {
    print("Creaaaaaaaaaaaaaaaate User info nuuuuuul image>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    profileInfo(profileUrl: "");
  }

  }

  void profileInfo({String? profileUrl}) async{
    if (usernameController.text.isNotEmpty) {
      print("Creaaaaaaaaaaaaaaaate  info>>>>>>>>>>>>>>>>>>>>>>>>>>>???????????>>>>>");
      await UserRepository.instance.createUser(
           UserModel(
            email: "",
            username: usernameController.text,
            phoneNumber: UserRepository.instance.auth.currentUser!.phoneNumber,
            status: "Hey There! I'm using WhatsApp Clone",
            isOnline: false,
            profileUrl: profileUrl,
          )
      );
      Get.offAll(() => const HomePage());

    }
  }
}
