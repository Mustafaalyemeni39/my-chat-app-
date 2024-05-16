import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/welcome/welcome_page.dart';



class SettingPageController extends GetxController {
  static SettingPageController get instance => Get.find();
  //
  // final storage = GetStorage();
  // final Rx<Country> selectedFilteredDialogCountry = CountryPickerUtils.getCountryByPhoneCode("967").obs;
  final phoneController = TextEditingController();
}
