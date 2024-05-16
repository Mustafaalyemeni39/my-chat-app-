import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:mustafachatclone/features/chat/controllers/chat/chat_controller.dart';
import 'package:mustafachatclone/features/chat/models/message_model.dart';
import 'package:mustafachatclone/features/chat/pages/single_chat_page.dart';

import '../../../global/theme/style.dart';
import '../../../global/widgets/profile_widget.dart';
class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
        body: Obx((){
          if (!controller.isChatLoading.value){
            final chats = controller.chats.value;
            if (chats.isEmpty) {
              return const Center(
                child: Text("No Conversations Yet"),
              );
            }
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (_,index){
                  final chat = chats[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SingleChat(currentConversation: MessageModel(
                          senderUid: chat.senderUid,
                          recipientUid: chat.recipientUid,
                          senderName: chat.senderName,
                          recipientName: chat.recipientName,
                        senderProfile: chat.senderProfile,
                        recipientProfile: chat.recipientProfile,
                      )
                      )
                      ));
                    },
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: profileWidget(imageUrl: chat.recipientProfile),
                        ),
                      ),
                      title: Text(chat.recipientName??"Unknown"),
                      subtitle: Text(chat.recentTextMessage??"No Recent Message", maxLines: 1, overflow: TextOverflow.ellipsis,),
                      trailing: Text(
                        DateFormat.jm().format(chat.createdAt!.toDate()),

                        style: const TextStyle(color: greyColor, fontSize: 13),
                      ),
                    ),
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







