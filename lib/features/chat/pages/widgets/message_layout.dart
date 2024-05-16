import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mustafachatclone/features/chat/models/message_reply_model.dart';
import 'package:mustafachatclone/features/chat/pages/widgets/message_widgets/message_type_widget.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../global/message_type_const.dart';
import '../../../../global/theme/style.dart';
import 'message_widgets/message_replay_type_widget.dart';
class MessageLayout extends StatelessWidget {
  const MessageLayout({Key? key, this.messageBgColor,
    this.onSwipe, this.message="", this.messageType, this.isShowTick,
    this.isSeen, this.onLongPress, this.rightPadding, this.alignment, this.createAt, this.reply, required this.recipientName}) : super(key: key);
  final Color? messageBgColor;
  final Alignment? alignment;
  final Timestamp? createAt;
  final VoidCallback? onSwipe;
  final String message;
  final String recipientName;
  final String? messageType;
  final bool? isShowTick;
  final bool? isSeen;
  final MessageReplayModel? reply;
  final VoidCallback? onLongPress;
  final double? rightPadding;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SwipeTo(
        onRightSwipe: (detail){
          onSwipe!();
        },
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: alignment,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 5, right: messageType == MessageTypeConst.textMessage ? rightPadding! : 5, top: 5, bottom: 5),
                        //padding: EdgeInsets.only(left: 5,top: 5,right: 88,bottom: 5),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(color: messageBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            reply?.message == null || reply?.message == ""
                                ? const SizedBox() :Container(
                              height: reply!.messageType ==
                                  MessageTypeConst.textMessage ? 70 : 80,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: 4.5,
                                    decoration: BoxDecoration(
                                        color: reply?.username == recipientName ? Colors.deepPurpleAccent
                                            : tabColor,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft:
                                            Radius.circular(15))),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${reply?.username == recipientName ? reply?.username : "You"}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: reply?.username == recipientName
                                                    ? Colors.deepPurpleAccent
                                                    : tabColor
                                            ),
                                          ),
                                          MessageReplayTypeWidget(
                                            message: reply?.message,
                                            type: reply?.messageType,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            MessageTypeWidget(message: message,type: messageType,),
                          ],
                        )
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(DateTime.now()),
                          style: const TextStyle(fontSize: 12, color: greyColor)),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowTick == true
                          ? Icon(
                        isSeen == true ? Icons.done_all : Icons.done,
                        size: 16,
                        color: isSeen == true ? Colors.blue : greyColor,
                      )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
