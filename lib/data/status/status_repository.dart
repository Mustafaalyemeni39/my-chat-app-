import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/status/models/status_imge_model.dart';
import 'package:mustafachatclone/features/status/models/status_model.dart';

import '../../global/const/firebase_collection_const.dart';

class StatusRepository extends GetxController {
  static StatusRepository get instance => Get.find();

  final  fireStore = FirebaseFirestore.instance;


  Future<void> createStatus(StatusModel status) async {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status);
  ///get id not for any one in status table
    final statusId = statusCollection.doc().id;

    final newStatus = StatusModel(
      imageUrl: status.imageUrl,
      profileUrl: status.profileUrl,
      uid: status.uid,
      createdAt: status.createdAt,
      phoneNumber: status.phoneNumber,
      username: status.username,
      statusId: statusId,
      caption: status.caption,
      stories: status.stories,
    ).toDocument();

    final statusDocRef = await statusCollection.doc(statusId).get();

    try {
      if (!statusDocRef.exists) {
        print("Hiiiiiiiiiiiiiiiiiiiiiii while creating status");
        statusCollection.doc(statusId).set(newStatus);
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while creating status");
    }

  }


  Future<void> deleteStatus(StatusModel status) async {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status);

    try {
      statusCollection.doc(status.statusId).delete();
    } catch (e) {
      print("some error occur while deleting status");
    }

  }

  Stream<List<StatusModel>> getMyStatus(String uid) {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));


    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }

  Future<List<StatusModel>> getMyStatusFuture(String uid) {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));

    return statusCollection.get().then((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }


  Stream<List<StatusModel>> getStatuses() {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));


    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }


  Future<void> seenStatusUpdate(String statusId, int imageIndex, String userId) async {
    try {
      final statusDocRef = fireStore
          .collection(FirebaseCollectionConst.status)
          .doc(statusId);

      final statusDoc = await statusDocRef.get();

      final stories = List<Map<String, dynamic>>.from(statusDoc.get('stories'));

      final viewersList = List<String>.from(stories[imageIndex]['viewers']);

      // Check if the user ID is already present in the viewers list
      if (!viewersList.contains(userId)) {
        viewersList.add(userId);

        // Update the viewers list for the specified image index
        stories[imageIndex]['viewers'] = viewersList;

        await statusDocRef.update({
          'stories': stories,
        });
      }


    } catch (error) {
      print('Error updating viewers list: $error');
    }
  }

  Future<void> updateOnlyImageStatus(StatusModel status) async {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status);

    final statusDocRef = await statusCollection.doc(status.statusId).get();

    try {
      if (statusDocRef.exists) {

        final existingStatusData = statusDocRef.data()!;
        final createdAt = existingStatusData['createdAt'].toDate();

        // check if the existing status is still within its 24 hours period
        if (createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
          // if it is, update the existing status with the new stores (images, or videos)

          final stories = List<Map<String, dynamic>>.from(statusDocRef.get('stories'));

          stories.addAll(status.stories!.map((e) => StatusImage.toJsonStatic(e)));
          // final updatedStories = List<StatusImageEntity>.from(existingStatusData['stories'])
          //   ..addAll(status.stories!);

          await statusCollection.doc(status.statusId).update({
            'stories': stories,
            'imageUrl': stories[0]['url']
          });
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while updating status stories");
    }
  }


  Future<void> updateStatus(StatusModel status) async {
    final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status);

    Map<String, dynamic> statusInfo = {};

    if (status.imageUrl != "" && status.imageUrl != null) {
      statusInfo['imageUrl'] = status.imageUrl;
    }

    if (status.stories != null) {
      statusInfo['stories'] = status.stories;
    }

    statusCollection.doc(status.statusId).update(statusInfo);
  }

}
