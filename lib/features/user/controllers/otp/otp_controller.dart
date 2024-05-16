import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/user/screens/home/home_page.dart';
import 'package:mustafachatclone/features/user/screens/initial_profile_submit_page/initial_profile_submit_page.dart';

import '../../../../data/user/user_repository.dart';
import '../../../../global/const/app_const.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();
  final otpController = TextEditingController();


  void submitSmsCode() async{
    print("otpCode ${otpController.text}");
    if (otpController.text.isNotEmpty){

      await UserRepository.instance.signInWithPhoneNumber(otpController.text);
      UserRepository.instance.screenRedirect();
     //Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => const InitialProfileSubmitPage()));

    }else{
      toast("Enter your OTP number");

    }
  }
}
