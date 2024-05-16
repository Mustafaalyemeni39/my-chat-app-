import 'dart:ffi';
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
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/const/app_const.dart';
import '../../../../global/message_type_const.dart';
import '../../../../global/widgets/show_image_picked_widget.dart';
import '../../../../global/widgets/show_video_picked_widget.dart';
import '../../../../storage/storage_provider.dart';

class SingleChatAudioController extends GetxController {
  static SingleChatAudioController get instance => Get.find();
  // SingleChatAudioController({required this.audioUrl});
  // final String audioUrl;
  final RxBool isPlaying = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {

    super.onInit();

  }



  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print("Closeedddddddddddddddddddddddddddddddddddddd Single Chat");
    }
  }



}
