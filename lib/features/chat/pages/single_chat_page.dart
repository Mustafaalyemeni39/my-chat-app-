
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/chat/models/message_model.dart';
import 'package:mustafachatclone/features/chat/models/message_reply_model.dart';
import 'package:mustafachatclone/features/chat/pages/widgets/attach_window_item.dart';
import 'package:mustafachatclone/features/chat/pages/widgets/message_layout.dart';
import 'package:mustafachatclone/features/chat/pages/widgets/message_widgets/message_replay_preview_widget.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';
import 'package:mustafachatclone/features/user/models/user_model.dart';

import '../../../global/theme/style.dart';
import '../../../global/widgets/dialog_widget.dart';
import '../controllers/single_chat/single_chat_controller.dart';
class SingleChat extends StatelessWidget {
  const SingleChat({Key? key, required this.currentConversation}) : super(key: key);
  final MessageModel currentConversation;


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SingleChatController(),tag: currentConversation.recipientUid);
    controller.setUsersChat(currentConversation);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.scrollToBottom();
    });


    // final controllerr = Get.create(()=>SingleChatController(),);
    // final controller = Get.put(SingleChatController());
    // print("buildddddddddddddddddd");
    // print("See it : ${Get.find<SingleChatController>().counter.value}");
    // Get.find<SingleChatController>(tag: "s").counter.value=Get.find<SingleChatController>(tag: "s").counter.value+1;
    // print("after change ");
    // print("See it : ${Get.find<SingleChatController>().counter.value}");


    // controller.getMessages(message);
  //  child: StreamBuilder<List<MessageModel>>(stream: controller.getMessages(), builder: (context,AsyncSnapshot<List<MessageModel>>snapShot){


    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<List<UserModel>>(stream: UserController.instance.getSingleUserStream(currentConversation.recipientUid!), builder: (context,AsyncSnapshot<List<UserModel>> snapShot){
          if(snapShot.data != null){
            final recipientUser =  snapShot.data?.first;

            return Column(
              children: [
                Text(recipientUser!.username??""),
                recipientUser.isOnline == true ?  const Text(
                "Online", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),)
                    :Container()
              ],
            );
          }
          else{
            return const Column(
              children: [
                Text("Unknown"),
              ],
            );
          }

        }),
        actions: [

             GestureDetector(
              onTap: () {

                // ChatUtils.makeCall(context, callEntity: CallEntity(
                //   callerId: widget.message.senderUid,
                //   callerName: widget.message.senderName,
                //   callerProfileUrl: widget.message.senderProfile,
                //   receiverId: widget.message.recipientUid,
                //   receiverName: widget.message.recipientName,
                //   receiverProfileUrl: widget.message.recipientProfile,
                // ));
              },
              child: const Icon(
                Icons.videocam_rounded,
                size: 25,
              ),
            ),

          const SizedBox(
            width: 25,
          ),
          const Icon(
            Icons.call,
            size: 22,
          ),
          const SizedBox(
            width: 25,
          ),
          const Icon(
            Icons.more_vert,
            size: 22,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),


      body:     GestureDetector(
          onTap: () {
            controller.isShowAttachWindow.value = false;
    },
      child: Obx(
          (){
             // final messages = controller.messages.value;
              return Stack(
                children: [
                  /// Image Background Chat
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Image.asset("assets/whatsapp_bg_image.png", fit: BoxFit.cover),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<MessageModel>>(stream: controller.getMessages(), builder: (context,AsyncSnapshot<List<MessageModel>>snapShot){
                          if(snapShot.data != null){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.scrollToBottom();
                            });
                            final messages = snapShot.data!;
                            return ListView.builder(
                              controller: controller.scrollController,
                              itemCount: messages.length,
                              itemBuilder: (_,index){
                                final postedMessage = messages[index];
                                if(postedMessage.isSeen == false  && postedMessage.recipientUid == currentConversation.senderUid) {
                              print("sender reciver");
                              controller.seenMessageUpdate( MessageModel(
                                  senderUid: currentConversation.senderUid,
                                  recipientUid: currentConversation.recipientUid,
                                  messageId: postedMessage.messageId
                              ));
                                }
                                if(postedMessage.senderUid == currentConversation.senderUid){

                                  print(postedMessage.senderUid == controller.usersChat.senderUid);
                                  return MessageLayout(
                                      messageType:postedMessage.messageType,
                                      message: postedMessage.message??"",
                                    rightPadding: postedMessage.repliedMessage == "" ? 85 : 5,
                                    alignment: Alignment.centerRight,
                                      isSeen: postedMessage.isSeen,
                                      isShowTick: true,
                                      createAt: postedMessage.createdAt,
                                      messageBgColor: messageColor,
                                    reply: MessageReplayModel(
                                        message: postedMessage.repliedMessage,
                                        messageType: postedMessage.repliedMessageType,
                                        username: postedMessage.repliedTo
                                    ),
                                      onLongPress: (){
                                        controller.focusNode.unfocus();
                                        displayAlertDialog(
                                            context,
                                            onTap: () {

                                             controller.deleteMessage(message: MessageModel(
                                                  senderUid: postedMessage.senderUid,
                                                  recipientUid: postedMessage.recipientUid,
                                                  messageId: postedMessage.messageId
                                              ));
                                              Navigator.pop(context);
                                            },
                                            confirmTitle: "Delete",
                                            content: "Are you sure you want to delete this message?"
                                        );
                                      },
                                      onSwipe: (){
                                        controller.onMessageSwipe(
                                            message: postedMessage.message,
                                            username: postedMessage.senderName,
                                            type: postedMessage.messageType,
                                            isMe: true
                                        );

                                      }, recipientName: postedMessage.recipientName!,

                                  );
                                }else{

                                  return MessageLayout(
                                    messageType: postedMessage.messageType,
                                    message: postedMessage.message??"",

                                    alignment: Alignment.centerLeft,
                                    createAt: postedMessage.createdAt,
                                    isSeen: postedMessage.isSeen,
                                    isShowTick: false,
                                    messageBgColor: senderMessageColor,
                                    rightPadding: postedMessage.repliedMessage == "" ? 85 : 5,
                                    reply: MessageReplayModel(
                                        message: postedMessage.repliedMessage,
                                        messageType: postedMessage.repliedMessageType,
                                        username: postedMessage.repliedTo
                                    ),
                                    onLongPress: (){
                                      controller.focusNode.unfocus();
                                      displayAlertDialog(
                                          context,
                                          onTap: () {

                                            controller.deleteMessage(message: MessageModel(
                                                senderUid: postedMessage.senderUid,
                                                recipientUid: postedMessage.recipientUid,
                                                messageId: postedMessage.messageId
                                            ));
                                            Navigator.pop(context);
                                          },
                                          confirmTitle: "Delete",
                                          content: "Are you sure you want to delete this message?"
                                      );
                                    },
                                    onSwipe: (){
                                      controller.onMessageSwipe(
                                          message: postedMessage.message,
                                          username: postedMessage.senderName,
                                          type: postedMessage.messageType,
                                          isMe: false
                                      );
                                    }, recipientName: postedMessage.recipientName!,
                                  );

                                }
                              },
                            );
                          }
                          return const Center(
                            child: Text("Error Loading... "),
                          );

                        }),
                      ),
                      /// message replay:
                      controller.isReplying.value == true
                          ? const SizedBox(
                        height: 5,
                      )
                          : const SizedBox(
                        height: 0,
                      ),

                      controller.isReplying.value == true
                          ? Row(
                        children: [
                          Expanded(
                            child: MessageReplayPreviewWidget(
                              onCancelReplayListener: () {
                                controller.setMessageReplay( MessageReplayModel());
                                controller.isReplying.value = false;
                              }, recipientUid: currentConversation.recipientUid!,
                            ),
                          ),
                          Container(
                            width: 60,
                          ),
                        ],
                      )
                          : Container(),

                      ///  Input Row:///////
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top:  5, bottom: 5),
                        child: Row(
                          children: [
                            /// Text Input
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: appBarColor, borderRadius:  BorderRadius.circular(25)),
                                height: 50,
                                child: TextField(
                                    focusNode: controller.focusNode,
                                  onTap: () {
                                    controller.isShowAttachWindow .value= false;
                                    controller.isShowEmojiKeyboard.value = false;
                                  },
                                  controller: controller.textMessageController,
                                  onChanged: (value) {
                                    if(value.isNotEmpty){
                                      controller.textMessageController.text=value;
                                      controller.isDisplaySendButton.value = true;
                                    }else{
                                      controller.textMessageController.text=value;
                                      controller.isDisplaySendButton.value = false;
                                    }

                                  },

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                    prefixIcon: GestureDetector(
                                      onTap: controller.toggleEmojiKeyboard,
                                      child: Icon(
                                          controller.isShowEmojiKeyboard.value == false
                                              ? Icons.emoji_emotions
                                              : Icons.keyboard_outlined,
                                          color: greyColor),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Wrap(
                                        children: [
                                          Transform.rotate(
                                            angle: -0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.isShowAttachWindow.value = ! controller.isShowAttachWindow.value;

                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: greyColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                           onTap: (){
                                             controller.selectImage();
                                           },
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: greyColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: 'Message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            /// Send Button
                            GestureDetector(
                              onTap: () {
                             controller.sendText(

                                 // message: MessageModel(
                                 //   senderUid: message.senderUid,
                                 //   recipientUid: message.recipientUid,
                                 //   senderName: message.senderName,
                                 //   recipientName: message.recipientName,
                                 //  // senderProfile: message.senderProfile,
                                 //   //recipientProfile: message.recipientProfile,
                                 //   message: textMessageController.text,
                                 //   createdAt: Timestamp.now(),
                                 //   isSeen:false,
                                 //   messageType:MessageTypeConst.textMessage,
                                 //   repliedMessage:"",
                                 //   repliedTo:"",
                                 //   repliedMessageType: MessageTypeConst.textMessage,
                                 //   // messageId:"",
                                 // ));
                             );
                            controller.textMessageController.clear();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: tabColor),
                                child: Center(
                                  child: Icon(
                                    controller.isDisplaySendButton.value ||  controller.textMessageController.text.isNotEmpty ? Icons.send_outlined :  controller.isRecording.value ? Icons.close : Icons.mic,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      controller.isShowEmojiKeyboard.value
                          ? SizedBox(
                        height: 310,
                        child: Stack(
                          children: [
                            EmojiPicker(
                              config:
                              const Config(bgColor: backgroundColor),
                              onEmojiSelected: ((category, emoji) {
                                controller.textMessageController.text =
                                    controller.textMessageController.text +
                                        emoji.emoji;

                              }),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration:
                                const BoxDecoration(color: appBarColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .emoji_emotions_outlined,
                                            size: 20,
                                            color: tabColor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            Icons.gif_box_outlined,
                                            size: 20,
                                            color: greyColor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            Icons.ad_units,
                                            size: 20,
                                            color: greyColor,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            controller.textMessageController
                                                .text =
                                                controller.textMessageController

                                                    .text
                                                    .substring(
                                                    0,
                                                    controller.textMessageController

                                                        .text
                                                        .length - 2);

                                          },
                                          child: const Icon(
                                            Icons.backspace_outlined,
                                            size: 20,
                                            color: greyColor,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                          : const SizedBox(),


                    ],
                  ),
                  /// isShowAttachWindow
                  controller.isShowAttachWindow.value ? Positioned(
                    bottom: 65,
                    top: 320,
                    left: 15,
                    right: 15,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.20,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      decoration: BoxDecoration(
                        color: bottomAttachContainerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AttachWindowItem(
                                icon: Icons.document_scanner,
                                color: Colors.deepPurpleAccent,
                                title: "Document",
                              ),
                              AttachWindowItem(
                                  icon: Icons.camera_alt,
                                  color: Colors.pinkAccent,
                                  title: "Camera",
                                  onTap: () {}),
                              AttachWindowItem(icon: Icons.image, color: Colors.purpleAccent, title: "Gallery"),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AttachWindowItem(icon: Icons.headphones, color: Colors.deepOrange, title: "Audio"),
                              AttachWindowItem(icon: Icons.location_on, color: Colors.green, title: "Location"),
                              AttachWindowItem(
                                  icon: Icons.account_circle, color: Colors.deepPurpleAccent, title: "Contact"),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const AttachWindowItem(
                                icon: Icons.bar_chart,
                                color: tabColor,
                                title: "Poll",
                              ),
                              AttachWindowItem(
                                  icon: Icons.gif_box_outlined,
                                  color: Colors.indigoAccent,
                                  title: "Gif",
                                  onTap: () {
                                    controller.sendGifMessage();
                                  }),
                              AttachWindowItem(
                                  icon: Icons.videocam_rounded,
                                  color: Colors.lightGreen,
                                  title: "Video",
                                  onTap: () {
                                    controller.selectVideo();


                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                      : Container(),

                ],
              );

          }
      ),
    ),
    );

  }
}
