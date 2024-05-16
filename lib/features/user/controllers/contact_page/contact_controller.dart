import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';
import 'package:mustafachatclone/features/user/models/contact_model.dart';
import 'package:mustafachatclone/features/user/models/user_model.dart';

import '../../screens/welcome/welcome_page.dart';



class ContactPageController extends GetxController {
  static ContactPageController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
     getAllUsers();
  } //

  final RxList<ContactModel> contactNumbers = <ContactModel>[].obs;
  final RxList<UserModel> usersNumbers = <UserModel>[].obs;
  final RxBool contactNumbersLoaded = false.obs;


  Future<void> getDeviceNumber() async{
    contactNumbers.value= await UserRepository.instance.getDeviceNumber();
    // usersNumbers.value = await UserRepository.instance.getDeviceNumber();
    contactNumbersLoaded.value = true;

  }


  void getAllUsers() {
    // contactNumbers.value= await UserRepository.instance.getDeviceNumber();
    final streamResponse =  UserRepository.instance.getAllUsers();
    streamResponse.listen((users) {
      usersNumbers.value = users;
    });
    
    contactNumbersLoaded.value = true;

  }
}
