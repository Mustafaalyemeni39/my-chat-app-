import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/theme/style.dart';
import '../../../../global/widgets/profile_widget.dart';
import '../../controllers/initial_profile_submit_page/initial_profile_submit_page_controller.dart';
import '../home/home_page.dart';
class InitialProfileSubmitPage extends StatelessWidget {
  const InitialProfileSubmitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controlller = Get.put(InitialProfileSubmitPageController());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            const Center(child: Text("Profile Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tabColor),),),
            const SizedBox(height: 10,),
            const Text("Please provide your name and an optional profile photo", textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                controlller.selectImage();
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Obx(()=> profileWidget(image: controlller.image!.value)),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                      BorderSide(color: tabColor, width: 1.5))),
              child: TextField(
                controller: controlller.usernameController,
                decoration: const InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap:(){
                 controlller.submitProfileInfo();

              },
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
