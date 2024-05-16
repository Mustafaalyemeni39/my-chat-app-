import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';
import 'package:mustafachatclone/features/user/models/user_model.dart';
import '../../../global/const/app_const.dart';
import '../../../storage/storage_provider.dart';



class UserController extends GetxController {
  static UserController get instance => Get.find();

  @override
  void onInit() {

    getSingleUser();

    usernameController.text=user.value.username!;
    aboutController.text=user.value.status!;
  } //
  // final storage = GetStorage();
  // final Rx<Country> selectedFilteredDialogCountry = CountryPickerUtils.getCountryByPhoneCode("967").obs;
  final phoneController = TextEditingController();

  final usernameController = TextEditingController();
  final aboutController = TextEditingController();

  final Rx<File>? image = File("").obs;
  final Rx<UserModel> user = UserModel.empty().obs;
  final Rx<bool> getSingleUserLoading = false.obs;
  final Rx<bool> getSingleUserLoaded = false.obs;
  final Rx<bool> isProfileUpdating = false.obs;
  final Rx<bool> getSingleUserFailure = false.obs;
 // File? _image;

  final userRepository = Get.put(UserRepository()); //try make it instance

  // Future<void> getSingleUser({required String uid}) async {
  //   emit(GetSingleUserLoading());
  // getSingleUser(String uid){
  //   final streamResponse = getSingleUserStream(uid);
  //   streamResponse.listen((users) {
  //     //  emit(GetSingleUserLoaded(singleUser: users.first));
  //
  //   });
  // }
  getSingleUser(){

    final streamResponse = getSingleUserStream(userRepository.auth.currentUser!.uid);
    streamResponse.listen((users) {
      //  emit(GetSingleUserLoaded(singleUser: users.first));
      user.value= users.first;
      print("The User iS >>>>>>>>>>>> ${user.value.uid}");
      usernameController.text=user.value.username!;
      aboutController.text=user.value.status!;

    });
  }

  Stream<List<UserModel>> getSingleUserStream(String uid) {
    return userRepository.getSingleUser(uid);
  }



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
    if( image!.value.uri.toString().isNotEmpty ) {
      await StorageProviderRemoteDataSource.uploadProfileImage(
          file: image!.value,
          onComplete: (onProfileUpdateComplete) {
            isProfileUpdating.value = onProfileUpdateComplete;
          }
      ).then((profileImageUrl) async{
        await profileInfo(
            profileUrl: profileImageUrl
        );
      });
    } else {
      await profileInfo(profileUrl: user.value.profileUrl);
    }


  }

  Future<void> profileInfo({String? profileUrl}) async {
    if (usernameController.text.isNotEmpty) {

         await UserRepository.instance.updateUser(
             UserModel(
        uid:  user.value.uid,
        email: "",
        username: usernameController.text,
        phoneNumber: user.value.phoneNumber,
        status: aboutController.text,
        isOnline: user.value.isOnline,
        profileUrl:profileUrl,
          ))
          .then((value) {
        toast("Profile updated");
      });
    }
  }


  void updateUser(UserModel userUpdated) async {

    userRepository.updateUser(userUpdated);

  }

  void updateUserOnline({  required String? uid, required bool isOnline,}) async {

    userRepository.updateUserOnline(UserModel(
      isOnline: isOnline,
      uid: uid,
    ));

  }

}

