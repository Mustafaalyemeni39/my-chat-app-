import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/data/chat/chat_repository.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';
import 'package:mustafachatclone/features/chat/models/chat_model.dart';
import 'package:mustafachatclone/features/chat/models/message_model.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final RxBool isChatLoading = false.obs;
  final controller = Get.put(ChatRepository());
  final userController = Get.put(UserController());
  final RxList<ChatModel> chats = <ChatModel>[].obs;



  @override
  void onInit() {
    super.onInit();
    getMyChat( ChatModel(senderUid: UserRepository.instance.auth.currentUser!.uid));
  } //
  void deleteChat(ChatModel chat) async {
    await controller.deleteChat(chat);
  }


  Stream<List<ChatModel>> getMyChatStream(ChatModel chat) {
    return controller.getMyChat(chat);
  }

  void getMyChat(ChatModel chat) {

    // isChatLoading.value = true;
    final streamResponse =controller.getMyChat(chat);
    streamResponse.listen((chats) {
      this.chats.value= chats;

    });
    isChatLoading.value = false;
  }


}
