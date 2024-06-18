import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/call/models/call_model.dart';
import 'package:mustafachatclone/features/call/pages/call_page.dart';

import '../../../global/widgets/profile_widget.dart';
import '../controllers/call/call_history_page_controller.dart';

class PickUpCallPage extends StatefulWidget {
  final String? uid;
  final Widget child;

  const PickUpCallPage({Key? key, required this.child, this.uid})
      : super(key: key);

  @override
  State<PickUpCallPage> createState() => _PickUpCallPageState();
}

class _PickUpCallPageState extends State<PickUpCallPage> {
  // final callController = CallController.instance;
  final callController = Get.put(CallController());
  @override
  void initState() {
    callController.getUserCalling(widget.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        final call = callController.userCall.value;

        if (call.isCallDialed == false) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Incoming Call',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                profileWidget(imageUrl: call.receiverProfileUrl),
                const SizedBox(height: 40),
                Text(
                  "${call.receiverName}",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        callController.leaveChannel().then((value) {
                          callController
                              .updateCallHistoryStatus(CallModel(
                                  callId: call.callId,
                                  callerId: call.callerId,
                                  receiverId: call.receiverId,
                                  isCallDialed: false,
                                  isMissed: true))
                              .then((value) {
                            callController.endCall(CallModel(
                              callerId: call.callerId,
                              receiverId: call.receiverId,
                            ));
                          });
                        });
                      },
                      icon: const Icon(Icons.call_end, color: Colors.redAccent),
                    ),
                    const SizedBox(width: 25),
                    IconButton(
                      onPressed: () {
                        callController
                            .getCallChannelId(call.receiverId!)
                            .then((callChannelId) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CallPage(
                                      callEntity: CallModel(
                                          callId: callChannelId,
                                          callerId: call.callerId!,
                                          receiverId: call.receiverId!)
                                  )
                              )
                          );

                          print("callChannelId = $callChannelId");
                        });
                      },
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        print("Nooooooooooooo Callllllllllling Nowwwwwwwwwwwwwwwwww  its Nullllll if (call.isCallDialed == false) ");
        return widget.child;


    });
  }
}
