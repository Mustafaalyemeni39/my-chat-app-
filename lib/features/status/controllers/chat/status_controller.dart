import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/data/status/status_repository.dart';
import 'package:mustafachatclone/data/user/user_repository.dart';
import 'package:mustafachatclone/features/status/models/status_model.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';
import 'package:path/path.dart' as path;

import '../../../../global/widgets/show_image_and_video_widget.dart';
import '../../../../storage/storage_provider.dart';
import '../../models/status_imge_model.dart';

class StatusController extends GetxController {
  static StatusController get instance => Get.find();
  final RxBool isChatLoading = false.obs;
  final RxBool statusLoaded = false.obs;
  final RxBool myStatusLoaded = false.obs;
  final controller = Get.put(StatusRepository());
  final currentUser = UserController.instance.user;
  final Rx<StatusModel> myStatuses = StatusModel().obs;
  final RxList<StatusImage> _stories = <StatusImage>[].obs;
  final RxList<StoryItem> myStories = <StoryItem>[].obs;

  final RxList<File> _selectedMedia = <File>[].obs;
  final RxList<String> _mediaTypes =
      <String>[].obs; // To store the type of each selected file
  final RxList<StatusModel> statuses = <StatusModel>[].obs;
/// what diff ??  currentUser.value.uid
/// {UserRepository.instance.auth.currentUser!.uid
  @override
  void onInit() async {
    if (kDebugMode) {
      print("onInit Method of Status Controller Use Id === ${UserRepository.instance.auth.currentUser!.uid}");
    }
    super.onInit();
    getStatuses();
    getMyStatus(uid:  UserRepository.instance.auth.currentUser!.uid);
    // getMyStatusFuture(UserController.instance.user.value.uid!);
    // BlocProvider.of<StatusCubit>(context).getStatuses(status: StatusEntity());
    //
    // BlocProvider.of<GetMyStatusCubit>(context).getMyStatus(
    //     uid: widget.currentUser.uid!);
    //
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   di.sl<GetMyStatusFutureUseCase>()
    //       .call(widget.currentUser.uid!).then((myStatus) {
    //     if (myStatus.isNotEmpty && myStatus.first.stories != null) {
    //       _fillMyStoriesList(myStatus.first);
    //     }
    //   });
    // });
  }

  Future<void> selectMedia() async {
    _selectedMedia.value = <File>[];
    _mediaTypes.value = <String>[];

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia.value =
            result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes.value = List<String>.filled(_selectedMedia.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia.length; i++) {
          print("mediaTypes YOUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUselected no is  $i");
          String extension =
              path.extension(_selectedMedia[i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.webp' ||
              extension == '.png') {
            _mediaTypes[i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes[i] = 'video';
          }
        }
        print("mediaTypes  mediaTypes mediaTypes   mediaTypes mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  Future fillMyStoriesList(StatusModel status) async {
    if (status.stories != null) {
      _stories.value = status.stories!;
      List<StoryItem> newListStoriesItems = [];
      print("Storyies @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ is ${_stories.length}");
      for (StatusImage story in status.stories!) {
        print("Storyies is ${story.url}");
        newListStoriesItems.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
      myStories.value = newListStoriesItems;
    }
    else{
      myStories.value = [];
      _stories.value = [];
    }
  }

  Future showStatusImageViewBottomModalSheet(
      {StatusModel? status, required List<StoryItem> stories}) async {
    print("storieas $stories");
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: Get.context!,
      builder: (context) {
        return FlutterStoryView(
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: stories,
          enableOnHoldHide: false,
          caption: "This is very beautiful photo",
          onPageChanged: (index) {
            seenStatusUpdate(
                imageIndex: index,
                userId: currentUser.value.uid!,
                statusId: status.statusId!);
          },
          createdAt: status!.createdAt!.toDate(),
        );
      },
    );
  }

  uploadImageStatus() {
    StorageProviderRemoteDataSource.uploadStatuses(
            files: _selectedMedia,
        onComplete: (onCompleteStatusUpload) {}
    ).then((statusImageUrls) {
      List<StatusImage> storiesSelected = [];
      for (var i = 0; i < statusImageUrls.length; i++) {
        print("File is ?????????? ${statusImageUrls[i]}");
        storiesSelected.add(StatusImage(
          url: statusImageUrls[i],
          type: _mediaTypes[i],
          viewers: const [],
        ));
      }
      _stories.value = storiesSelected;
      print("Seeeeeeeeeeeeeeeeeeee User Isssssssssssssssssssssssssssssssssssssssss");
      print(currentUser.value.uid!);
      controller.getMyStatusFuture(currentUser.value.uid!).then((fMyStatus) {
        if (fMyStatus.isNotEmpty) {
          print(
              "update only  updateOnlyImageStatus??????????????????????????????");
          updateOnlyImageStatus(
              status: StatusModel(
                  statusId: fMyStatus.first.statusId, stories: _stories));
        } else {
          print(
              "Creaete New Statusssssssss QQQQQQQQQQQQQQQQ");
          createStatus(
            status: StatusModel(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.value.username,
                uid: currentUser.value.uid,
                profileUrl: currentUser.value.profileUrl,
                imageUrl: statusImageUrls[0],
                phoneNumber: currentUser.value.phoneNumber),
          ).then((value) {
            // Navigator.pushReplacement(
            //     Get.context!,
            //     MaterialPageRoute(
            //         builder: (_) => HomePage(
            //           // uid: widget.currentUser.uid!,
            //           // index: 1,
            //         )));
          });
        }
      });
    });
  }

  void eitherShowOrUploadSheet(StatusModel? myStatus) {
    if (myStatus != null) {
      showStatusImageViewBottomModalSheet(status: myStatus, stories: myStories);
    } else {
      print("selectMedia selectMedia  selectMedia  selectMedia  selectMedia>>>>>>>>>>>>>>>>>");
      selectMedia().then(
        (value) {
          if (_selectedMedia.isNotEmpty) {
            print("_selectedMedia _selectedMedia not null ?????????????????????????");
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: Get.context!,
              builder: (context) {
                return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia,
                  onTap: () {
                    uploadImageStatus();
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  Future<void> getMyStatus({required String uid}) async {
    try {
      print(uid);

      /// snapshots not run hen erorr its retun nulll value null not empty
      /// /// snapshots not run hen erorr its retun nulll value null not empty/// snapshots not run hen erorr its retun nulll value null not empty/// snapshots not run hen erorr its retun nulll value null not empty
      /// /// snapshots not run hen erorr its retun nulll value null not empty/// snapshots not run hen erorr its retun nulll value null not empty
      ///
      ///
      ///
      ///
      // emit(GetMyStatusLoading());
      final streamResponse = controller.getMyStatus(uid);
      myStatusLoaded.value = true;
      streamResponse.listen((newMyStatus) {
        print("#############################Listningggg>>> ^__^");
        print("#############################Listningggg>>> ^__^");
        print("#############################Listningggg>>> ^__^");
        print("#############################Listningggg>>> ^__^");

        if (newMyStatus.isEmpty) {
          print("Itsss Emptyyyyyy Empty = $newMyStatus");
          this.myStatuses.value = StatusModel();
          _stories.value = [];
          myStories.value = [];

          // getMyStatusFuture(UserController.instance.user.value.uid!);
          // emit(const GetMyStatusLoaded(myStatus: null));
          myStatusLoaded.value = true;
        } else {
          print("Notttttttttttt Empty = $myStatuses");
          myStatuses(newMyStatus.first);
          if (newMyStatus.isNotEmpty && newMyStatus.first.stories != null) {
            fillMyStoriesList(newMyStatus.first);
          }

          ///what divs myStatuses,value= statuses.first;
          // emit(GetMyStatusLoaded(myStatus: statuses.first));
          myStatusLoaded.value = true;
        }
      });
    } on SocketException {
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
      // emit(GetMyStatusFailure());
    } catch (_) {
      // emit(GetMyStatusFailure());
    }
  }

  Future<void> getStatuses() async {
    try {
      print(
          "statuses getStatuses  getStatuses getStatuses Functionnnnnnn work");
      final streamResponse = controller.getStatuses();
      streamResponse.listen((newStatuses) {
        print(
            "#############################getStatuses >>>  mmmmmmmmmmmmmmmmmm");
        print("getStatuses Function  statuses = $statuses");
        statuses.value = newStatuses;
        statusLoaded.value = true;
        // emit(StatusLoaded(statuses: statuses));
      });
    } on SocketException {
      // emit(StatusFailure());
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
    } catch (_) {
      // emit(StatusFailure());
    }
  }

  Future<void> createStatus({required StatusModel status}) async {
    try {
      await controller.createStatus(status);
    } on SocketException {
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
      // emit(StatusFailure());
    } catch (_) {
      // emit(StatusFailure());
    }
  }

  Future<void> deleteStatus({required StatusModel status}) async {
    try {
      await controller.deleteStatus(status);
    } on SocketException {
      // emit(StatusFailure());
    } catch (_) {
      // emit(StatusFailure());
    }
  }

  Future<void> updateStatus({required StatusModel status}) async {
    try {
      await controller.updateStatus(status);
    } on SocketException {
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
      // emit(StatusFailure());
    } catch (_) {
      // emit(StatusFailure());
    }
  }

  Future<void> updateOnlyImageStatus({required StatusModel status}) async {
    try {
      await controller.updateOnlyImageStatus(status);
    } on SocketException {
      // emit(StatusFailure());
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
    } catch (_) {
      // emit(StatusFailure());
    }
  }

  void getMyStatusFuture(String uid) async {
    controller.getMyStatusFuture(uid).then((myStatusFuture) {
      if (myStatusFuture.isNotEmpty && myStatusFuture.first.stories != null) {
        fillMyStoriesList(myStatusFuture.first);
      }
    });
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@ Starts");
  }

  Future<void> seenStatusUpdate(
      {required String statusId,
      required int imageIndex,
      required String userId}) async {
    try {
      await controller.seenStatusUpdate(statusId, imageIndex, userId);
    } on SocketException {
      // emit(StatusFailure());
      if (kDebugMode) {
        print("No Internettttttttttttttttttt");
      }
    } catch (_) {
      // emit(StatusFailure());
    }
  }
}
