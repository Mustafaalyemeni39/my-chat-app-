
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../global/message_type_const.dart';
import '../../../../../global/theme/style.dart';
import '../../../controllers/single_chat/single_chat_controller.dart';
import 'message_replay_type_widget.dart';

class MessageReplayPreviewWidget extends StatelessWidget {
  final VoidCallback? onCancelReplayListener;
  final String recipientUid;
  const MessageReplayPreviewWidget({Key? key, this.onCancelReplayListener, required this.recipientUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Get.put(SingleChatController(),tag: recipientUid);

    return Obx(
        ()=> Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: provider.messageReplay.value.messageType == MessageTypeConst.textMessage? 90 : 100,
        decoration: const BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor.withOpacity(.4)
          ),
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: 3.5,
                decoration: BoxDecoration(
                  color: provider.messageReplay.value.isMe == true? tabColor : Colors.deepPurpleAccent,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("${provider.messageReplay.value.isMe == true? "You" : provider.messageReplay.value.username}", style: TextStyle(fontWeight: FontWeight.bold, color: provider.messageReplay.value.isMe == true? tabColor : Colors.deepPurpleAccent),)),
                          GestureDetector(onTap: onCancelReplayListener, child: const Icon(Icons.close, size: 18, color: greyColor,)),
                        ],
                      ),
                      const SizedBox(height: 3,),

                      provider.messageReplay.value.messageType == MessageTypeConst.textMessage ? Text("${provider.messageReplay.value.message}", maxLines: 2,style: const TextStyle(fontSize: 12, color: greyColor, overflow: TextOverflow.ellipsis),) : Row(
                        children: [
                          MessageReplayTypeWidget(
                            message: provider.messageReplay.value.message,
                            type: provider.messageReplay.value.messageType,
                          ),
                        ],
                      ),
                     // Text("${BlocProvider.of<CommunicationCubit>(context).messageReplay.message}", maxLines: 2,style: TextStyle(fontSize: 12, color: greyColor, overflow: TextOverflow.ellipsis),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
