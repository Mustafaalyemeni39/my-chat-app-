
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel  {
  final String? username;
  final String? email;
  final String? phoneNumber;
  final bool? isOnline;
  final String? uid;
  final String? status; // like hi there im using whats up
  final String? profileUrl;

  const UserModel({
    this.username,
    this.email,
    this.phoneNumber,
    this.isOnline,
    this.uid,
    this.status,
    this.profileUrl,
  }) ;

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
        status: snap['status'],
        profileUrl: snap['profileUrl'],
        phoneNumber: snap['phoneNumber'],
        isOnline: snap['isOnline'],
        email: snap['email'],
        username: snap['username'],
        uid: snap['uid']
    );
  }

  static UserModel empty() => const UserModel(
      status: "",
      profileUrl: "",
      phoneNumber: "",
      isOnline: false,
      email: "",
      username: "",
      uid: ""
  );

  Map<String, dynamic> toDocument() => {
    "status": status,
    "profileUrl": profileUrl,
    "phoneNumber": phoneNumber,
    "isOnline": isOnline,
    "email": email,
    "username": username,
    "uid": uid
  };
}