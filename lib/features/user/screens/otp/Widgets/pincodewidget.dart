import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../global/theme/style.dart';
import '../../../controllers/otp/otp_controller.dart';
class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controlller = Get.put(OtpController());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          PinCodeFields(
            controller: controlller.otpController,
            length: 6,
            activeBorderColor: tabColor,
            onComplete: (String pinCode) {},
          ),
          const Text("Enter your 6 digit code")
        ],
      ),
    );
  }
}
