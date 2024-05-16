import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/user/screens/login/login.dart';
import 'package:mustafachatclone/features/user/screens/settings/edit_profile_page.dart';
import 'package:mustafachatclone/features/user/screens/settings/widgets/settings_Item_widget.dart';
import '../../../../data/user/user_repository.dart';
import '../../../../global/theme/style.dart';
import '../../../../global/widgets/dialog_widget.dart';
import '../../../../global/widgets/profile_widget.dart';
import '../../controllers/setting_page/setting_controller.dart';
import '../../controllers/user_controller.dart';
class SettingPage extends StatelessWidget {
  const SettingPage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
   // final settingController = Get.put(SettingPageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:Obx(
              ()=> Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, PageConst.editProfilePage);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                    },
                    child: SizedBox(
                      width: 65,
                      height: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.5),
                        child:
                        profileWidget(imageUrl: userController.user.value.profileUrl),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                   Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userController.user.value.username!,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          userController.user.value.status!,
                          style: TextStyle(color: greyColor),
                        )
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.qr_code_sharp,
                    color: tabColor,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 2,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: greyColor.withOpacity(.4),
          ),
          const SizedBox(height: 10,),

          SettingsItem(
              title: "Account",
              description: "Security applications, change number",
              icon: Icons.key,
              onTap: () {}
          ),
          SettingsItem(
              title: "Privacy",
              description: "Block contacts, disappearing messages",
              icon: Icons.lock,
              onTap: () {}
          ),
          SettingsItem(
              title: "Chats",
              description: "Theme, wallpapers, chat history",
              icon: Icons.message,
              onTap: () {}
          ),
          SettingsItem(
              title: "Logout",
              description: "Logout from WhatsApp Clone",
              icon: Icons.exit_to_app,
              onTap: () {
                displayAlertDialog(
                    context,
                    onTap: () {
                      UserRepository.instance.signOut();
                      // Navigator.pushNamedAndRemoveUntil(context, PageConst.welcomePage, (route) => false);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),(route) => false);

                    },
                    confirmTitle: "Logout",
                    content: "Are you sure you want to logout?"
                );
              }
          ),
        ],
      ),
    );
  }
}
