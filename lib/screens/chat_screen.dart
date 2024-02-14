import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izipizi_chat/api/api.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String routeName = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _listMessages = [];

  @override
  Widget build(BuildContext context) {
    final dialogChatUser =
        ModalRoute.of(context)!.settings.arguments as ChatUser;

    final double mqd = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(
            dialogChatUser,
            mqd,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      log('Data: ${jsonEncode(data![0].data())}');

                      _listMessages.clear();
                      _listMessages.add(
                        Message(
                            toid: '123',
                            msg: 'Hi',
                            read: '12:00 AM',
                            type: MessageType.text,
                            fromid: APIs.user.uid,
                            sent: '11:59 AM'),
                      );

                      _listMessages.add(
                        Message(
                            toid: APIs.user.uid,
                            msg: 'Hello!',
                            read: '12:00 AM',
                            type: MessageType.text,
                            fromid: '777',
                            sent: '12:05 AM'),
                      );

                      log('Data: $_listMessages');
                      if (_listMessages.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _listMessages.length,
                          itemBuilder: (context, index) {
                            return MessageCard(
                              messages: _listMessages[index],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('Say Hi 🖐️! To new user!😜'),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: PalletColors.cGray,
            ),
          ),
          const Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLength: null,
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: PalletColors.cGrayText,
                    fontSize: 14.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        14.0,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: PalletColors.cGrayField,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        14.0,
                      ),
                    ),
                  ),
                  hintText: 'Type Something ...'),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.image_outlined,
              size: 24,
              color: PalletColors.cGray,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_outlined,
              size: 24,
              color: PalletColors.cGray,
            ),
          ),
          IconButton.filled(
            onPressed: () {},
            color: PalletColors.cCyan600,
            icon: const Icon(
              Icons.send_outlined,
              size: 18,
              color: PalletColors.cWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(ChatUser dialogChatUser, double mqd) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: PalletColors.cCyan600,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: dialogChatUser.image,
              ),
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: mqd - 180,
                child: Text(
                  dialogChatUser.name,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: PalletTextStyles.bodyMedium,
                ),
              ),
              Text(
                'Last seen aviable',
                style: PalletTextStyles.bodySmall
                    .copyWith(color: PalletColors.cGrayText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}