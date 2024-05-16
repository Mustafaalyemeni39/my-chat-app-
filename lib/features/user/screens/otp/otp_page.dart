import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/theme/style.dart';
import '../../controllers/otp/otp_controller.dart';
import 'Widgets/pincodewidget.dart';
class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controlller = Get.put(OtpController());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      "Verify your OTP",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter your OTP for the WhatsApp Clone Verification (so that you will be moved for the further steps to complete)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  PinCodeWidget(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context) => const InitialProfileSubmitPage()));
controlller.submitSmsCode();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
