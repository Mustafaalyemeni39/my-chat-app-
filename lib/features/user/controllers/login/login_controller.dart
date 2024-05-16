
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mustafachatclone/features/user/screens/otp/otp_page.dart';

import '../../../../data/user/user_repository.dart';
import '../../../../global/const/app_const.dart';
import '../../../../global/theme/style.dart';
import '../../screens/login/Widgets/country_dialog_item.dart';


class LoginController extends GetxController {
  static LoginController get instance => Get.find();


  @override

  final storage = GetStorage();
  final Rx<Country> selectedFilteredDialogCountry = CountryPickerUtils.getCountryByPhoneCode("967").obs;
  final phoneController = TextEditingController();

  void onInit() {
    final storage = GetStorage();
    storage.write('isFirstTime', false);
    phoneController.text = "771317970";


  }
  /// --- login
  void submitVerifyPhoneNumber() async {
    String phoneNumber="";
    if (phoneController.text.isNotEmpty) {
      phoneNumber="+${selectedFilteredDialogCountry.value.phoneCode}${phoneController.text}";
      print("phoneNumber Hiiiiiiiiiiiiiii $phoneNumber");
      await UserRepository.instance.verifyPhoneNumber(phoneNumber);
      Get.offAll(() => const OtpPage());

    } else {
      toast("Enter your phone number");
    }
  }
  void openFilteredCountryPickerDialog(BuildContext context) {
    showDialog(
        // context: Get.overlayContext!,
        context: context,
        builder: (_) =>
            Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: tabColor,
                ),
                child: CountryPickerDialog(
                  titlePadding: const EdgeInsets.all(8.0),
                  searchCursorColor: tabColor,
                  searchInputDecoration: const InputDecoration(
                    hintText: "Search",
                  ),
                  isSearchable: true,
                  title: const Text("Select your phone code"),
                  onValuePicked: (Country country) {
                    selectedFilteredDialogCountry.value = country;

                  },
                  itemBuilder: buildDialogItem,
                )
            ));
  }

  Widget buildDialogItem(Country country) {
    return CountryDialogItem( country: country,);
  }
}
