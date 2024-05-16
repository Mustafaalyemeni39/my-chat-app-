
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';

import '../../../../global/theme/style.dart';
import '../../controllers/login/login_controller.dart';
import 'Widgets/country_dialog_item.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(LoginController());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Text(
                      "Verify your phone number",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor),
                    ),
                  ),
                  const Text(
                    "WhatsApp Clone will send you SMS message (carrier charges may apply) to verify your phone number. Enter the country code and phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    onTap: (){
                      controller.openFilteredCountryPickerDialog(context);
                    },
                    title: Obx(()=> CountryDialogItem(country: controller.selectedFilteredDialogCountry.value,)),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.50,
                              color: tabColor,
                            ),
                          ),
                        ),
                        width: 80,
                        height: 42,
                        alignment: Alignment.center,
                        child: Obx(
                          ()=> Text(
                              "+ "+controller.selectedFilteredDialogCountry.value.phoneCode),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 1.5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: tabColor, width: 1.5))),
                          child: TextField(
                            controller: controller.phoneController,
                            decoration: const InputDecoration(
                                hintText: "Phone Number",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpPage()));
                controller.submitVerifyPhoneNumber();
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
