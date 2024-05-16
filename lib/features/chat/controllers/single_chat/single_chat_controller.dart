import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mustafachatclone/data/chat/chat_repository.dart';
import 'package:mustafachatclone/features/chat/models/chat_model.dart';
import 'package:mustafachatclone/features/chat/models/message_model.dart';
import 'package:mustafachatclone/features/chat/models/message_reply_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/const/app_const.dart';
import '../../../../global/message_type_const.dart';
import '../../../../global/widgets/show_image_picked_widget.dart';
import '../../../../global/widgets/show_video_picked_widget.dart';
import '../../../../storage/storage_provider.dart';

class SingleChatController extends GetxController {

  static SingleChatController get instance => Get.find();
  final RxBool isShowAttachWindow = false.obs;
  // final RxBool isMessageLoading = false.obs;
  final RxBool isDisplaySendButton = false.obs;
  final RxBool isRecordInit = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool isReplying = false.obs;
  final RxBool isShowEmojiKeyboard = false.obs;
  FlutterSoundRecorder? _soundRecorder;

  final RxString repliedTo = "".obs;
  final RxString repliedMessageType = "".obs;
  final RxString repliedMessage = "".obs;

  final RxList<MessageModel> messages = <MessageModel>[].obs;
   final textMessageController = TextEditingController();
  final controller = Get.put(ChatRepository());
  final Rx<File> image = File("").obs;
  final Rx<File> video = File("").obs;
    final Rx<MessageReplayModel> messageReplay = MessageReplayModel().obs;
  late MessageModel usersChat;
  final ScrollController scrollController  = ScrollController();
  final RxBool isPlaying = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();


  FocusNode focusNode = FocusNode();


  @override
  void onInit() {
    if (kDebugMode) {
      print("INITTTTTTTTTTTTTTTTTTTTTTTTTTTTTT ");
    }
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    super.onInit();

  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print("Closeedddddddddddddddddddddddddddddddddddddd Single Chatcontroller");
    }

  }

  void _hideEmojiContainer() {
    isShowEmojiKeyboard.value = false;
  }

  void _showEmojiContainer() {

    isShowEmojiKeyboard.value = true;

  }

  void _showKeyboard() => focusNode.requestFocus();
  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard.value) {
      _showKeyboard();
      _hideEmojiContainer();
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }


  void onMessageSwipe({String? message, String? username, String? type, bool? isMe}) {
   setMessageReplay ( MessageReplayModel(
       message: message,
       username: username,
       messageType: type,
       isMe: isMe
   ));
   isReplying.value= true;
  }


  void setMessageReplay(MessageReplayModel newMessageReplay) {
    messageReplay(newMessageReplay);
    print("Swiipppppppppppppttttttt messageReplay dta is ");

    print(messageReplay.value.username);

  }
  void setUsersChat(MessageModel users) {
    usersChat = users;
  }

  Future<void> _openAudioRecording() async {
    const permission = Permission.microphone;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
           await _soundRecorder!.openRecorder();
           isRecordInit.value = true;
        // Permission is granted
      }
    }else{
       await _soundRecorder!.openRecorder();
       isRecordInit.value = true;
    }
  }

  Future<void> scrollToBottom() async {
    if (scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void selectImage() async{
    _selectImage().then((value) {
      if (image.value != null && image.value.path.isNotEmpty) {
        WidgetsBinding.instance
            .addPostFrameCallback(
              (timeStamp) {
            showImagePickedBottomModalSheet(
                Get.context!,
                recipientName:usersChat
                    .recipientName,
                file: image.value,
                onTap: () {
                  sendImageMessage();
                  Navigator.pop(
                      Get.context!);
                });
          },
        );
      }
    });
  }
  void selectVideo() async{
    _selectVideo().then((value) {
      if (video.value != null && video.value.path.isNotEmpty) {
        WidgetsBinding.instance
            .addPostFrameCallback(
              (timeStamp) {
            showVideoPickedBottomModalSheet(
                Get.context!,
                recipientName: usersChat.recipientName,
                file: video.value,
                onTap: () {
                  sendVideoMessage();
                  Navigator.pop(Get.context!);
                });
          },
        );
      }
    });


      isShowAttachWindow.value = false;

  }

  Future _selectImage() async {
     image.value =File("");
    try {
      final pickedFile =
      await ImagePicker.platform.getImageFromSource(source: ImageSource.gallery);


        if (pickedFile != null) {
          image.value = File(pickedFile.path);
        } else {
          if (kDebugMode) {
            print("no image has been selected");
          }
        }

    } catch (e) {
      toast("some error occurred $e");
    }
  }
  Future _selectVideo() async {
    image.value =File("");
    try {
      final pickedFile =
      await ImagePicker.platform.getVideo(source: ImageSource.gallery);


        if (pickedFile != null) {
          video.value = File(pickedFile.path);
        } else {
          if (kDebugMode) {
            print("no video has been selected");
          }
        }

    } catch (e) {
      toast("some error occurred $e");
    }
  }


  void deleteMessage({required MessageModel message}) async {
    await controller.deleteMessage(message);
  }
  Stream<List<MessageModel>> getMessages() {
    // controller.getMessages(message)
    // isMessageLoading.value = true;
    return getMessagesStream(usersChat);

    // isMessageLoading.value = false;
  }
  Stream<List<MessageModel>> getMessagesStream(MessageModel message) {
    return controller.getMessages(message);
  }
  Future<void> seenMessageUpdate(MessageModel message) async {
    controller.seenMessageUpdate(message);
  }


///Send Media Messages
  void sendText() async {

    if(isDisplaySendButton.value || textMessageController.text.isNotEmpty) {
      if (isReplying.value) {
        _sendMessage(
            message: MessageModel(
                senderUid: usersChat.senderUid,
                recipientUid: usersChat.recipientUid,
                senderName: usersChat.senderName,
                recipientName: usersChat.recipientName,
                messageType: MessageTypeConst.textMessage,
                repliedMessage: messageReplay.value.message,
                repliedTo: messageReplay.value.username,
                repliedMessageType:messageReplay.value.messageType,
                message: textMessageController.text
            )
        );
        isReplying.value = false;
      }
      else{
        _sendMessage(
            message: MessageModel(
                senderUid: usersChat.senderUid,
                recipientUid: usersChat.recipientUid,
                senderName: usersChat.senderName,
                recipientName: usersChat.recipientName,
                messageType: MessageTypeConst.textMessage,
                repliedMessage: "",
                repliedTo: "",
                repliedMessageType: "",
                message: textMessageController.text
            )
        );

      }
    }
    else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!isRecordInit.value) {
        return;
      }
      if (isRecording.value == true) {
        await _soundRecorder!.stopRecorder();
        StorageProviderRemoteDataSource.uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: usersChat.senderUid,
          otherUid: usersChat.recipientUid,
          type: MessageTypeConst.audioMessage,
        ).then((audioUrl) {
          _sendMessage(
              message:   MessageModel(
                  senderUid: usersChat.senderUid,
                  recipientUid: usersChat.recipientUid,
                  senderName: usersChat.senderName,
                  recipientName: usersChat.recipientName,
                  // createdAt: message.createdAt,
                  repliedTo: repliedTo.value,
                  repliedMessage: repliedMessage.value,
                  // isSeen: message.isSeen,
                  messageType: MessageTypeConst.audioMessage,
                  message: audioUrl,
                  repliedMessageType: repliedMessageType.value
              )
          );
        });
      } else {
        await _soundRecorder!.startRecorder(
          toFile: audioPath,
        );
      }
      isRecording.value = !isRecording.value;


    }

  }
  void _sendMessage({ required MessageModel message}) async  {
    scrollToBottom();
    controller.sendMessage(
      message: MessageModel(
          senderUid: message.senderUid,
          recipientUid: message.recipientUid,
          senderName: message.senderName,
          recipientName: message.recipientName,
          messageType: message.messageType,
          repliedMessage: message.repliedMessage ?? "",
          repliedTo: message.repliedTo ?? "",
          repliedMessageType: message.repliedMessageType ?? "",
          isSeen: false,
          createdAt: Timestamp.now(),
          message: message.message
      ),
      chat: ChatModel(
        senderUid: message.senderUid,
        recipientUid: message.recipientUid,
        senderName: message.senderName,
        recipientName: message.recipientName,
        senderProfile: message.senderProfile,
        recipientProfile: message.recipientProfile,
        createdAt: Timestamp.now(),
        totalUnReadMessages: 0,
      ),
    );

    scrollToBottom();
  }
  void sendImageMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: image!.value,
      onComplete: (value) {
        isUploading.value = value;
      },
      uid: usersChat.senderUid,
      otherUid: usersChat.recipientUid,
      type: MessageTypeConst.photoMessage,
    ).then((photoImageUrl) {

      _sendMessage(
          message: MessageModel(
          senderUid: usersChat.senderUid,
          recipientUid: usersChat.recipientUid,
          senderName: usersChat.senderName,
          recipientName: usersChat.recipientName,
          // createdAt: message.createdAt,
          repliedTo: repliedTo.value,
          repliedMessage: repliedMessage.value,
          // isSeen: message.isSeen,
          messageType: MessageTypeConst.photoMessage,
          message: photoImageUrl,
          repliedMessageType: repliedMessageType.value
      )
      );
      //sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }
  void sendVideoMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: video!.value,
      onComplete: (value) {},
      uid: usersChat.senderUid,
      otherUid: usersChat.recipientUid,
      type: MessageTypeConst.videoMessage,
    ).then((videoUrl) {
      _sendMessage(
          message: MessageModel(
              senderUid: usersChat.senderUid,
              recipientUid: usersChat.recipientUid,
              senderName: usersChat.senderName,
              recipientName: usersChat.recipientName,
              // createdAt: message.createdAt,
              repliedTo: repliedTo.value,
              repliedMessage: repliedMessage.value,
              // isSeen: message.isSeen,
              messageType: MessageTypeConst.videoMessage,
              message: videoUrl,
              repliedMessageType: repliedMessageType.value
          ));
  });
}
  Future sendGifMessage() async {
    final gif = await pickGIF();

    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(
          message: MessageModel(
              senderUid: usersChat.senderUid,
              recipientUid: usersChat.recipientUid,
              senderName: usersChat.senderName,
              recipientName: usersChat.recipientName,
              // createdAt: message.createdAt,
              repliedTo: repliedTo.value,
              repliedMessage: repliedMessage.value,

              messageType: MessageTypeConst.gifMessage,
              message: fixedUrl,
              repliedMessageType: repliedMessageType.value
          )
      );

    }
  }
}
