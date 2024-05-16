

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mustafachatclone/features/chat/models/chat_model.dart';
import 'package:mustafachatclone/features/chat/models/message_model.dart';
import 'package:uuid/uuid.dart';

import '../../global/const/firebase_collection_const.dart';
import '../../global/message_type_const.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  final  fireStore = FirebaseFirestore.instance;


  @override
  void onReady() {
   // FlutterNativeSplash.remove();
   //  screenRedirect();
  }


  Future<void> sendMessage({required ChatModel chat, required MessageModel message}) async {

    await sendMessageBasedOnType(message);

    String recentTextMessage = "";

    switch (message.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = '📷 Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = '📸 Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = '🎵 Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }


    await addToChat(ChatModel(
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ));

  }

  Future<void> addToChat(ChatModel chat) async {

    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myChatRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.senderUid)
        .collection(FirebaseCollectionConst.myChat);

    final otherChatRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.recipientUid)
        .collection(FirebaseCollectionConst.myChat);

    final myNewChat = ChatModel(
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: chat.recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ).toDocument();

    final otherNewChat = ChatModel(
        createdAt: chat.createdAt,
        senderProfile: chat.recipientProfile,
        recipientProfile: chat.senderProfile,
        recentTextMessage: chat.recentTextMessage,
        recipientName: chat.senderName,
        senderName: chat.recipientName,
        recipientUid: chat.senderUid,
        senderUid: chat.recipientUid,
        totalUnReadMessages: chat.totalUnReadMessages)
        .toDocument();

    try {
      myChatRef.doc(chat.recipientUid).get().then((myChatDoc) async {
        // Create
        if (!myChatDoc.exists) {
          await myChatRef.doc(chat.recipientUid).set(myNewChat);
          await otherChatRef.doc(chat.senderUid).set(otherNewChat);
          return;
        } else {
          // Update
          await myChatRef.doc(chat.recipientUid).update(myNewChat);
          await otherChatRef.doc(chat.senderUid).update(otherNewChat);
          return;
        }
      });
    } catch (e) {
      print("error occur while adding to chat");
    }
  }

  Future<void> sendMessageBasedOnType(MessageModel message) async {

    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myMessageRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.messages);

    final otherMessageRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.messages);

    String messageId = const Uuid().v1();


    final newMessage = MessageModel(
        senderUid: message.senderUid,
        recipientUid: message.recipientUid,
        senderName: message.senderName,
        recipientName: message.recipientName,
        createdAt: message.createdAt,
        repliedTo: message.repliedTo,
        repliedMessage: message.repliedMessage,
        isSeen: message.isSeen,
        messageType: message.messageType,
        message: message.message,
        messageId: messageId,
        repliedMessageType: message.repliedMessageType)
        .toDocument();
    try {
      await myMessageRef.doc(messageId).set(newMessage);
      await otherMessageRef.doc(messageId).set(newMessage);
    } catch (e) {
      print("error occur while sending message");
    }

  }


  Future<void> deleteChat(ChatModel chat) async {
    final chatRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(chat.recipientUid);

    try {

      await chatRef.delete();

    } catch (e) {
      print("error occur while deleting chat conversation $e");
    }

  }

  Future<void> deleteMessage(MessageModel message) async {
    final messageRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.messages)
        .doc(message.messageId);

    try {

      await messageRef.delete();

    } catch (e) {
      print("error occur while deleting message $e");
    }
  }


  Stream<List<MessageModel>> getMessages(MessageModel message) {
    final messagesRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.messages)
        .orderBy("createdAt", descending: false);

    return messagesRef.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => MessageModel.fromSnapshot(e)).toList());

  }


  Stream<List<ChatModel>> getMyChat(ChatModel chat) {
    final myChatRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .orderBy("createdAt", descending: true);

    return myChatRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((e) => ChatModel.fromSnapshot(e)).toList());
  }


  Future<void> seenMessageUpdate(MessageModel message) async {
    final myMessagesRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.messages)
        .doc(message.messageId);

    final otherMessagesRef = fireStore
        .collection(FirebaseCollectionConst.users)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.messages)
        .doc(message.messageId);
    await myMessagesRef.update({"isSeen": true});
    await otherMessagesRef.update({"isSeen": true});
  }


}
