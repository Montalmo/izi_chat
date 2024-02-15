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

  Widget _companionMessage() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: PalletColors.cCyan600.withOpacity(0.2)),
            color: PalletColors.cCyanField,
            borderRadius: const BorderRadius.all(Radius.circular(14)).copyWith(
              bottomRight: const Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.messages.msg,
                style: PalletTextStyles.bodyMedium,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.messages.sent,
                    style: PalletTextStyles.caption.copyWith(
                      color: PalletColors.cGrayText,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.done_all_rounded,
                    color: PalletColors.cCyan600,
                    size: 16.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _myMessage() {
    return Row(children: [
      ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
        ),
        child: Container(
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
              bottomLeft: const Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.messages.msg,
                style: PalletTextStyles.bodyMedium,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                widget.messages.read,
                style: PalletTextStyles.caption.copyWith(
                  color: PalletColors.cGrayText,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
