import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izipizi_chat/helper/my_date_util.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../api/api.dart';
import '../utilits/pallets.dart';
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

  // for view or hiding emoji bar
  bool _showEmoji = false, isUploading = false;

  @override
  Widget build(BuildContext context) {
    final dialogChatUser =
        ModalRoute.of(context)!.settings.arguments as ChatUser;

    final double mqd = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: PopScope(
          canPop: _showEmoji ? false : true,
          onPopInvoked: (didPop) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
          },
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

                          _listMessages = data!
                              .map((e) => Message.fromJson(e.data()))
                              .toList();

                          if (_listMessages.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
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
                if (isUploading)
                  const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                _chatInput(dialogChatUser),
                const SizedBox(
                  height: 8.0,
                ),
                if (_showEmoji)
                  SizedBox(
                    height: 170.0,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: const Config(
                        bottomActionBarConfig: BottomActionBarConfig(
                          enabled: false,
                        ),
                        categoryViewConfig: CategoryViewConfig(
                            backgroundColor: PalletColors.cBGContainer),
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 32.0,
                          backgroundColor: PalletColors.cBGContainer,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatInput(ChatUser chatUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 4.0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                FocusScope.of(context).unfocus();
                _showEmoji = !_showEmoji;
              });
            },
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: _showEmoji ? PalletColors.cCyan600 : PalletColors.cGray,
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
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile?> images = await picker.pickMultiImage(
                imageQuality: 70,
              );
              if (images.isNotEmpty) {
                for (var element in images) {
                  setState(() => isUploading = true);
                  await APIs.sendChatImage(chatUser, File(element!.path));
                  setState(() => isUploading = false);
                }
              }
            },
            icon: const Icon(
              Icons.image_outlined,
              size: 24,
              color: PalletColors.cGray,
            ),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? photo = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 80,
              );
              if (photo != null) {
                setState(() => isUploading = true);
                await APIs.sendChatImage(
                  chatUser,
                  File(photo.path),
                );
                setState(() => isUploading = false);
              }
            },
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
                  MessageType.text,
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
      child: StreamBuilder(
          stream: APIs.getUserInfo(dialogChatUser),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
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
                      imageUrl: list.isNotEmpty
                          ? list[0].image
                          : dialogChatUser.image,
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
                        list.isNotEmpty ? list[0].name : dialogChatUser.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: PalletTextStyles.bodyMedium,
                      ),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive,
                                )
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: dialogChatUser.lastActive,
                            ),
                      style: PalletTextStyles.bodySmall
                          .copyWith(color: PalletColors.cGrayText),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
