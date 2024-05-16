import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';
import 'package:mustafachatclone/features/user/screens/settings/widgets/profile_item.dart';
import 'package:mustafachatclone/features/user/screens/settings/widgets/settings_widget_item.dart';

import '../../../../global/theme/style.dart';
import '../../../../global/widgets/profile_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: Obx(
            ()=> Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child:
                          (controller.image!.value.uri.toString().isNotEmpty)?
                            profileWidget(image:controller.image?.value)
                                : profileWidget(imageUrl: controller.user.value.profileUrl),

                          ),
                        ),

                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectImage();
                            //selectImage
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: tabColor,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: blackColor,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileItem(
                    controller: controller.usernameController,
                    title: "Name",
                    description: "Enter username",
                    icon: Icons.person,
                    onTap: () {}),
                ProfileItem(
                    controller: controller.aboutController,
                    title: "About",
                    description: "Hey there I'm using WhatsApp",
                    icon: Icons.info_outline,
                    onTap: () {}),
                SettingsItemWidget(
                    title: "Phone",
                    description: controller.user.value.phoneNumber,
                    icon: Icons.phone,
                    onTap: () {}),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    controller.submitProfileInfo();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tabColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // child: isProfileUpdating == true ? const Center(
                    //         child: SizedBox(
                    //           width: 25,
                    //           height: 25,
                    //           child: CircularProgressIndicator(
                    //             color: whiteColor,
                    //           ),
                    //         ),
                    //       ) :
                child:  const Center(
                            child: Text(
                              "Save",
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
        ));
  }
}
