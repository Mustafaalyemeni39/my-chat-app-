import 'dart:io';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/call/pages/call_page.dart';
import '../../../../data/call/call_repository.dart';
import '../../../../global/const/agora_config_const.dart';
import '../../models/call_model.dart';

class CallController extends GetxController {
  static CallController get instance => Get.find();

  final RxBool myCallHistoryLoading = false.obs;
  final RxBool myCallHistoryFailure = false.obs;
  final RxBool callDialed = false.obs;
  final RxBool callFailed = false.obs;
  final RxBool isCalling = false.obs;
  final controller = Get.put(CallRepository());

  // final userController = Get.put(UserController());
  final RxList<CallModel> myCallHistory = <CallModel>[].obs;
  final Rx<AgoraClient?> client = (null as AgoraClient?).obs;
  Rx<CallModel> userCall = CallModel().obs;


  Future<void> initialize({String? tokenUrl, String? channelName}) async {
    print("HIIIIIIIIIIIIIIIIIIIIIIIIIIII agoraraaaaaaa");
    print(tokenUrl);

    if (client.value == null) {
      print("Nuuuuuuuuuuuuuuuuuuuuul agoraraaaaaaa");
      client.value = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: AgoraConfig.agoraAppId,
          channelName: channelName!,
          tokenUrl: tokenUrl,
        ),
      );
      await client.value!.initialize();

    }
  }

  Future<void> leaveChannel() async {
    if (client.value != null) {
      await client.value!.engine.leaveChannel();
      await client.value!.engine.release();
      client.value = null; // Reset the client
    }
  }

  Future<void> getMyCallHistory({required String uid}) async {
    // emit(MyCallHistoryLoading());
    try {
      final streamResponse = controller.getMyCallHistory(uid);
      streamResponse.listen((myCallHistoryList) {
        if(myCallHistoryList.length>0){
          print("Not Nulllllllll myCallHistoryList");

        }else{
          print(" Nulllllllll myCallHistoryList");

        }

        myCallHistory.value=myCallHistoryList;
      });
    } on SocketException {
      // emit(MyCallHistoryFailure());
    } catch (_) {
      // emit(MyCallHistoryFailure());
    }
  }

  Future<void> getUserCalling(String uid) async {
    // isCalling.value = true;
    try {
      final streamResponse = controller.getUserCalling(uid);
      streamResponse.listen((userCalling) {
        if (userCalling.isEmpty) {
          userCall(CallModel());
        } else {
          userCall(userCalling.first);
        }
      });
    } on SocketException {
      /// it should make userCall empty userCall( CallModel());
      userCall(CallModel());
    } catch (_) {
      /// it should make userCall empty userCall( CallModel());

      userCall(CallModel());
    }
  }

  Future<void> makeCallButton(CallModel call) async {
    // isCalling.value = true;
    makeCall(call).then((value) => getCallChannelId(call.callerId!).then((callChannelId){
      Get.to(CallPage(
        callEntity:  CallModel(
          callId: callChannelId, callerId: call.callerId, receiverId: call.receiverId,
        )
        ,)
      );
      saveCallHistory(CallModel(
          callId: callChannelId,
          callerId: call.callerId,
          callerName: call.callerName,
          callerProfileUrl: call.callerProfileUrl,
          receiverId: call.receiverId,
          receiverName: call.receiverName,
          receiverProfileUrl: call.receiverProfileUrl,
          isCallDialed: false,
          isMissed: false)
      );
      if (kDebugMode) {
        print("callChannelId = $callChannelId");
      }
    }

    ));
  }
  Future<void> makeCall(CallModel call) async {
    // isCalling.value = true;
    try {
      await controller.makeCall(call);
    } on SocketException {
      userCall(CallModel());
    } catch (_) {
      userCall(CallModel());
    }
  }

  Future<void> endCall(CallModel call) async {
    // isCalling.value = true;
    try {
      await controller.endCall(call);
    } on SocketException {
      userCall(CallModel());
    } catch (_) {
      userCall(CallModel());
    }
  }

  Future<String> getCallChannelId(String uid) async {
    return await controller.getCallChannelId(uid);
  }


  Future<void> saveCallHistory(CallModel call) async {
    // isCalling.value = true;
    try {
      await controller.saveCallHistory(call);
    } on SocketException {
      userCall(CallModel());
    } catch (_) {
      userCall(CallModel());
    }
  }

  Future<void> updateCallHistoryStatus(CallModel call) async {
    // isCalling.value = true;
    try {
      await controller.updateCallHistoryStatus(call);
    } on SocketException {
      userCall(CallModel());
    } catch (_) {
      userCall(CallModel());
    }
  }

}