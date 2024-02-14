import 'package:flutter/material.dart';
import 'package:izipizi_chat/models/message.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

import '../api/api.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.messages,
  });

  final Message messages;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.messages.fromid
        ? _myMessage()
        : _companionMessage();
  }

  Widget _myMessage() {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(
          16.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white10,
          ),
          color: PalletColors.cGrayField,
          borderRadius: const BorderRadius.all(Radius.circular(14)).copyWith(
            topLeft: const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.messages.msg,
              style: PalletTextStyles.bodyMedium,
            ),
            Text(
              widget.messages.sent,
              style: PalletTextStyles.caption.copyWith(
                color: PalletColors.cGrayText,
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _companionMessage() {
    return Container();
  }
}
