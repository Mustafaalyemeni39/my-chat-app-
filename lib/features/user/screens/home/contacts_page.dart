import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mustafachatclone/features/user/controllers/contact_page/contact_controller.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';


import '../../../../global/theme/style.dart';
import '../../../../global/widgets/profile_widget.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/pages/single_chat_page.dart';

class ContactsPage extends StatefulWidget {


  const ContactsPage({super.key,});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactPageController());
    final currentUser = UserController.instance.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
      ),
      body:
          Obx((){
           if (controller.contactNumbersLoaded.value){
             final users = controller.usersNumbers.value.where((element) => element.uid != currentUser.uid).toList();

             if (users.isEmpty) {
               return const Center(
                 child: Text("No Contacts Yet"),
               );
             }
             return ListView.builder(
               itemCount: users.length,
                 itemBuilder: (_,index){
                   final user = users[index];
                   return ListTile(
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  SingleChat(
                           currentConversation: MessageModel(
                       senderUid: currentUser.uid,
                       recipientUid: user.uid,
                       senderName: currentUser.username ,
                           recipientName: user.username,
                           senderProfile: currentUser.profileUrl,
                           recipientProfile: user.profileUrl,
                           )
                          )
                         )
                       );

                     },
                     leading: SizedBox(
                       width: 50,
                       height: 50,
                       child: ClipRRect(
                           borderRadius: BorderRadius.circular(25),
                           child: profileWidget(imageUrl: user.profileUrl)
                       ),
                     ),
                     title: Text("${user.username}"),
                     subtitle: Text(user.status??"Hi there ! Im using whats up"),
                   );
                 }
             );
            }
           return const Center(
              child: CircularProgressIndicator(
                color: tabColor,
              ),
            );
          })

    );
  }
}

