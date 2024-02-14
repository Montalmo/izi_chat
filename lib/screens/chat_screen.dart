import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String routeName = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
        body: Center(child: Text('User: ${dialogChatUser.name}')),
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
