import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/status/controllers/chat/status_controller.dart';
import 'package:mustafachatclone/features/status/models/status_model.dart';
import 'package:mustafachatclone/features/status/pages/my_status_page.dart';
import 'package:mustafachatclone/features/status/pages/widgets/status_dotted_borders_widget.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';

import '../../../data/user/user_repository.dart';
import '../../../global/date/date_formats.dart';
import '../../../global/theme/style.dart';
import '../../../global/widgets/profile_widget.dart';
import '../models/status_imge_model.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final controller = StatusController.instance;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("build Status Page");
    }
    return Obx(() {
      if (controller.statusLoaded.value) {
        final statuses = controller.statuses
            .where((element) =>
        element.uid != UserRepository.instance.auth.currentUser?.uid)
            .toList();
        if (controller.myStatuses.value.profileUrl != null ){
          print(" UI not nulllllllllllllllllllllll");
        }else{
          print(" UI nulllllllllllllllllllllll");
        }
        if (controller.myStatusLoaded.value) {

          return _bodyWidget(statuses, myStatus: controller.myStatuses.value.imageUrl != null? controller.myStatuses.value:null );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      }

      return const Center(
          child: Text("Loading......")
      );
    });
  }

  _bodyWidget(List<StatusModel> statuses, {StatusModel? myStatus}) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      myStatus != null
                          ? GestureDetector(
                        onTap: () {
                          controller.eitherShowOrUploadSheet(myStatus);
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          margin: const EdgeInsets.all(12.5),
                          child: CustomPaint(
                            painter: StatusDottedBordersWidget(
                                isMe: true,
                                numberOfStories: myStatus.stories!.length,
                                spaceLength: 4,
                                images: myStatus.stories,
                                uid: UserRepository.instance.auth.currentUser?.uid),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 55,
                              height: 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: profileWidget(
                                    imageUrl: myStatus.imageUrl),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(
                              imageUrl: UserController
                                  .instance.user.value.profileUrl),
                        ),
                      ),
                      /// here somtimes the snapshot reteurn nul vale if table deleted and maek error chek null values so cheek values hen make filed lik ! for sure values null be exist but if not exist will crash app so check the object snapshot untill error this haapedned
                      /// snapshots not run hen erorr its retun nulll value null not empty
                      ///check what difrenet empty or null  myStatus != null  && myStatus!=StatusModel()
                      ///check what difrenet empty or null  myStatus != null  && myStatus!=StatusModel()
                      ///check what difrenet empty or null  myStatus != null  && myStatus!=StatusModel()
                      ///check what difrenet empty or null  myStatus != null  && myStatus!=StatusModel()
                      myStatus != null
                          ? Container()
                          : Positioned(
                        right: 10,
                        bottom: 8,
                        child: GestureDetector(
                          onTap: () {
                            controller.eitherShowOrUploadSheet(myStatus);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: tabColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 2, color: backgroundColor)),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My status",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.eitherShowOrUploadSheet(myStatus);
                            },
                            child: const Text(
                              "Tap to add your status update",
                              style: TextStyle(color: greyColor),
                            ),
                          )
                        ],
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyStatusPage(status: myStatus!)));
                    },
                    child: Icon(
                      Icons.more_horiz,
                      color: greyColor.withOpacity(.5),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Recent updates",
                  style: TextStyle(
                      fontSize: 15, color: greyColor, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: statuses.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final status = statuses[index];

                    List<StoryItem> stories = [];

                    for (StatusImage storyItem in status.stories!) {
                      stories.add(StoryItem(
                          url: storyItem.url!,
                          viewers: storyItem.viewers,
                          type:
                          StoryItemTypeExtension.fromString(storyItem.type!)));
                    }

                    return ListTile(
                      onTap: () {
                        controller.showStatusImageViewBottomModalSheet(
                            status: status, stories: stories);
                      },
                      leading: SizedBox(
                        width: 55,
                        height: 55,
                        child: CustomPaint(
                          painter: StatusDottedBordersWidget(
                              isMe: false,
                              numberOfStories: status.stories!.length,
                              spaceLength: 4,
                              images: status.stories,
                              uid:UserRepository.instance.auth.currentUser?.uid),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 55,
                            height: 55,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: profileWidget(imageUrl: status.imageUrl),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "${status.username}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(formatDateTime(status.createdAt!.toDate())),
                    );
                  })
            ],
          ),
        ));
  }
}

//
//
// return Scaffold(
// body: SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Stack(
// children: [
// Container(
// margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// width: 60,
// height: 60,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(30),
// child: profileWidget(),
// ),
// ),
//
// Positioned(
// right: 10,
// bottom: 8,
// child: GestureDetector(
// onTap: () {
// },
// child: Container(
// width: 25,
// height: 25,
// decoration: BoxDecoration(
// color: tabColor,
// borderRadius: BorderRadius.circular(25),
// border: Border.all(width: 2, color: backgroundColor)),
// child: const Center(
// child: Icon(
// Icons.add,
// size: 20,
// ),
// ),
// ),
// ),
// )
// ],
// ),
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// const Text(
// "My status",
// style: TextStyle(fontSize: 16),
// ),
// const SizedBox(
// height: 2,
// ),
// GestureDetector(
// onTap: () {
//
// },
// child: const Text(
// "Tap to add your status update",
// style: TextStyle(color: greyColor),
// ),
// )
// ],
// )),
//
// GestureDetector(
// onTap: () {
// Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyStatusPage(status: StatusModel(),)));
//
// },
// child: Icon(
// Icons.more_horiz,
// color: greyColor.withOpacity(.5),
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// ],
// ),
// const SizedBox(
// height: 10,
// ),
// const Padding(
// padding: EdgeInsets.only(left: 10.0),
// child: Text(
// "Recent updates",
// style: TextStyle(
// fontSize: 15, color: greyColor, fontWeight: FontWeight.w500),
// ),
// ),
// const SizedBox(height: 10,),
//
// ListView(
// physics: const NeverScrollableScrollPhysics(),
// shrinkWrap: true,
// children: List.generate(20, (index) => ListTile(
// onTap: () {
// },
// leading: SizedBox(
// width: 55,
// height: 55,
// child: CustomPaint(
// child: Container(
// margin: const EdgeInsets.all(3),
// width: 55,
// height: 55,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(30),
// child: profileWidget(),
// ),
// ),
// ),
// ),
// title: Text(
// "User",
// style: const TextStyle(fontSize: 16),
// ),
// subtitle: Text("datae"),
// ),),
// ),
// ],
// ),
// ));
