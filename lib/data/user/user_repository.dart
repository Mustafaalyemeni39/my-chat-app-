import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mustafachatclone/features/user/screens/home/home_page.dart';
import 'package:mustafachatclone/features/user/screens/initial_profile_submit_page/initial_profile_submit_page.dart';
import 'package:mustafachatclone/features/user/screens/welcome/welcome_page.dart';

import '../../features/user/models/contact_model.dart';
import '../../features/user/models/user_model.dart';
import '../../features/user/screens/login/login.dart';
import '../../global/const/app_const.dart';
import '../../global/const/firebase_collection_const.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final  fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String _verificationId = "";
  final deviceStorage = GetStorage();


  @override
  void onReady() {
   // FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to show relevant screen

  screenRedirect() async {
    final user = auth.currentUser;
    if (user != null) {
      print("User Existing  is HEreeeeeeeeeeeeeeeeeeeeeeeeeeauth.currentUser ${auth.currentUser!.uid} ");
     fireStore.collection(FirebaseCollectionConst.users).where("uid", isEqualTo: auth.currentUser!.uid).get().then((usr){
       print("HHHHHHHHHHHHHHHHHHHHH");
       print(usr.docs.length);
        usr.docs.isNotEmpty?    print("Existing In Table Users"):    print("Not Existing In Table Users");
         usr.docs.isNotEmpty?  Get.offAll(() => const InitialProfileSubmitPage()):  Get.offAll(() => const HomePage());
      });
      //
      // userDb.docs.map((e) => UserModel.fromSnapshot(e)).toList().isEmpty?

      // Get.offAll(() => const InitialProfileSubmitPage()):  Get.offAll(() => const HomePage());
    }else{
      print("Isnot  Authhhhhhhhhhhhhhhhhhhh");
      // local storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const WelcomePage());
    }

  }

  Future<void> createUser(UserModel user) async {

    final userCollection =
    fireStore.collection(FirebaseCollectionConst.users);

    final uid = await getCurrentUID();

    final newUser = UserModel(
        email: user.email,
        uid: uid,
        isOnline: user.isOnline,
        phoneNumber: user.phoneNumber,
        username: user.username,
        profileUrl: user.profileUrl,
        status: user.status
    ).toDocument();


    try {

      userCollection.doc(uid).get().then((userDoc) {

        if(!userDoc.exists) {
          userCollection.doc(uid).set(newUser);
        } else {
          userCollection.doc(uid).update(newUser);
        }
      });

      print("Doneeee userrrrrrrrr");
    } catch (e) {
      throw Exception("Error occur while creating user");
    }


  }



  Stream<List<UserModel>> getAllUsers() {
    final userCollection =
    fireStore.collection(FirebaseCollectionConst.users);
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());

  }
  Future<String> getCurrentUID() async => auth.currentUser!.uid;
  Future<List<ContactModel>> getDeviceNumber() async {
    List<ContactModel> contactsList=[];

    if(await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      for (var contact in contacts) {
        contactsList.add(
            ContactModel(
                name: contact.name,
                photo: contact.photo,
                phones: contact.phones
            )
        );
      }
    }

    return contactsList;
  }

  Stream<List<UserModel>> getSingleUser(String uid) {
    final userCollection =
    fireStore.collection(FirebaseCollectionConst.users).where("uid", isEqualTo: uid);
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  Future<void> signInWithPhoneNumber(String smsPinCode) async {

    try {

      final AuthCredential credential = PhoneAuthProvider.credential(
          smsCode: smsPinCode, verificationId: _verificationId);

      await auth.signInWithCredential(credential);
      print("Successfully done");


    } on FirebaseAuthException catch(e) {
      if(e.code == 'invalid-verification-code') {
        toast("Invalid Verification Code");
      } else if (e.code == 'quota-exceeded') {
        toast("SMS quota-exceeded");
      }
    } catch (e) {
      toast("Unknown exception please try again");
    }
  }


  Future<void> signOut() async => auth.signOut();

  Future<void> updateUser(UserModel user) async {
    final userCollection =
    fireStore.collection(FirebaseCollectionConst.users);

    Map<String, dynamic> userInfo = {};

    if(user.username != "" && user.username != null) userInfo['username'] = user.username;
    if(user.status != "" && user.status != null) userInfo['status'] = user.status;

    if(user.profileUrl != "" && user.profileUrl != null) userInfo['profileUrl'] = user.profileUrl;

    if(user.isOnline != null) userInfo['isOnline'] = user.isOnline;

    userCollection.doc(user.uid).update(userInfo);



  }
  Future<void> updateUserOnline(UserModel user) async {
    final userCollection =
    fireStore.collection(FirebaseCollectionConst.users);

    Map<String, dynamic> userInfo = {};
    if(user.isOnline != null) userInfo['isOnline'] = user.isOnline;
    userCollection.doc(user.uid).update(userInfo);



  }


  Future<void> verifyPhoneNumber(String phoneNumber) async  {

    phoneVerificationCompleted(AuthCredential authCredential) {
      print("phone verified : Token ${authCredential.token} ${authCredential.signInMethod}");
    }

    phoneVerificationFailed(FirebaseAuthException firebaseAuthException) {
      print(
        "phone failed : ${firebaseAuthException.message},${firebaseAuthException.code}",
      );
    }

    phoneCodeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      print("time out :$verificationId");
    }

    phoneCodeSent(String verificationId, int? forceResendingToken) {
      _verificationId = verificationId;
    }

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      timeout: const Duration(seconds: 60),
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
  }
















/// called from main.dart on app launch
  // @override
  // void onReady() {
  //   FlutterNativeSplash.remove();
  //   screenRedirect();
  // }

  /// Function to show relevant screen
  //
  // screenRedirect() async {
  //   final user = _auth.currentUser;
  //
  //   if (user != null) {
  //     /// There is user
  //     if (user.emailVerified) {
  //       /// init User specific storage
  //       await TLocalStorage.ini(user.uid);
  //       Get.offAll(() => const NavigationMenu());
  //     } else {
  //       Get.offAll(() => VerifyEmailScreen(
  //             email: _auth.currentUser?.email,
  //           ));
  //     }
  //   }
  //
  //   /// No user
  //   else {
  //     // local storage
  //     deviceStorage.writeIfNull('isFirstTime', true);
  //     deviceStorage.read('isFirstTime') != true
  //         ? Get.offAll(() => const LoginScreen())
  //         : Get.offAll(() => OnBoardingScreen());
  //   }
  // }

  /*    ..........................begin email & password sign in & sign up ......................      */



}
