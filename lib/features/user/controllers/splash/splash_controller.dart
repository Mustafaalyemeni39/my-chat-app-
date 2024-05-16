import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/welcome/welcome_page.dart';



class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  @override
  void onInit() {
    // Navigator.push(Get.context!, MaterialPageRoute(builder: (_)=>const WelcomePage()));

    super.onInit();

  }

}
