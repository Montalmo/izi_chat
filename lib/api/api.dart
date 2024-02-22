import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class APIs {
  //firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing to Firebase cloud database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing to Firebase Storage cloud database
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  //current user
  static late ChatUser me;

  //for cheking if user exist or not
  static Future userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //get current user data
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
        } else {
          await createUser().then((value) => getSelfInfo());
        }
      },
    );
  }

  //for udaiting userinformation
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update(
      {
        'name': me.name,
        'about': me.about,
      },
    );
  }

  //for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      about: 'Hey i`m new user IZIChat!',
      createAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //get all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //Update profile picture
  static Future<void> updateProfilePicture(File file) async {
    //... getting image file extention
    final extention = file.path.split('.').last;
    log('File: $extention');

    //... strage image file ref with path
    final ref = storage.ref().child('profile_picture/${user.uid}.$extention');

    //...uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extention'))
        .then((p0) => log('Data Transfered: ${p0.bytesTransferred / 1000} kb'));

    //...updaipig user ava image at datbase
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  //get usesr online offline status
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  ////************** ChatScreen IPIs ***************

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //get all messages from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, MessageType type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toid: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromid: user.uid,
      sent: time,
    );
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromid)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLatestMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
          (p0) => log('Data transfered: ${p0.bytesTransferred / 1000} Kb'),
        );

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, MessageType.image);
  }

  static Future<void> dleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toid)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == MessageType.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }
}
