import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izipizi_chat/api/api.dart';
import 'package:izipizi_chat/utilits/pallets.dart';
import 'package:svg_flutter/svg_flutter.dart';

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
  List<Message> _listMessages = [];
  final _textController = TextEditingController();

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
                stream: APIs.getAllMessages(dialogChatUser),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: SizedBox(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      _listMessages =
                          data!.map((e) => Message.fromJson(e.data())).toList();

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
            _chatInput(dialogChatUser),
          ],
        ),
      ),
    );
  }

  Widget _chatInput(ChatUser chatUser) {
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
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLength: null,
              controller: _textController,
              decoration: const InputDecoration(
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
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(
                  chatUser,
                  _textController.text,
                );
                _textController.text = '';
              }
            },
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                imageUrl: dialogChatUser.image,
                placeholder: (context, url) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: ColoredBox(
                    color: PalletColors.cGrayField,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    SvgPicture.asset('assets/svgs/def_avatar.svg'),
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
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
