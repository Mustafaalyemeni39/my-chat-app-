
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global/theme/style.dart';
import '../../../controllers/single_chat/single_chat_audio_controller.dart';

class MessageAudioWidget extends StatelessWidget {
  const MessageAudioWidget({Key? key, required this.audioUrl}) : super(key: key);

  final String audioUrl;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SingleChatAudioController(),tag: audioUrl);

    return Obx(
          ()=> Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 50),
            onPressed: () async {
              if (controller.isPlaying.value) {
                await controller.audioPlayer.pause();
                controller.isPlaying.value = false;

              } else {
                await controller.audioPlayer
                    .setUrl(audioUrl!)
                    .then((value) async {

                  controller.isPlaying.value = true;

                  await controller.audioPlayer.play().then((value) async {
                    controller.isPlaying.value = false;
                    await controller.audioPlayer.stop();
                  });
                });
              }
            },
            icon: Icon(
              controller.isPlaying.value ? Icons.pause_circle : Icons.play_circle,
              size: 30,
              color: greyColor,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          controller.isPlaying.value
              ? StreamBuilder<Duration>(
              stream: controller.audioPlayer.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 190,
                    height: 2,
                    child: LinearProgressIndicator(
                      value: snapshot.data!.inMilliseconds.toDouble() /
                          controller.audioPlayer.duration!.inMilliseconds.toDouble(),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: greyColor,
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 190,
                    height: 2,
                    child: const LinearProgressIndicator(
                      value: 0,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: greyColor,
                    ),
                  );
                }
              })
              : Container(
            margin: const EdgeInsets.only(top: 20),
            width: 190,
            height: 2,
            child: const LinearProgressIndicator(
              value: 0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
