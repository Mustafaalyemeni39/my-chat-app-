


import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/call/models/call_model.dart';

import '../../../global/theme/style.dart';
import '../controllers/call/call_history_page_controller.dart';

class CallPage extends StatefulWidget {
  final CallModel callEntity;
  const CallPage({Key? key, required this.callEntity}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {

  final callController = CallController.instance;

  @override
  void initState() {
    callController.initialize(
        channelName: widget.callEntity.callId!,
        tokenUrl: "http://192.168.43.168:3000/get_token?channelName=${widget.callEntity.callId}"
    );

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return callController.client.value == null
            ?  const Center(child: CircularProgressIndicator(color: tabColor,),)
            : SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: callController.client.value!),
              AgoraVideoButtons(
                client:callController.client!.value!,
                disconnectButtonChild: IconButton(
                  color: Colors.red,
                  onPressed: () async {
                    await callController.leaveChannel().then((value) {
                      callController
                          .endCall(CallModel(
                        callerId: widget.callEntity.callerId,
                        receiverId: widget.callEntity.receiverId,
                      ));
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.call_end),
                ),
              ),
            ],
          ),
        );
      })
    );
  }
}
