import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:izipizi_chat/helper/my_date_util.dart';
import 'package:izipizi_chat/models/message.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

import '../api/api.dart';
import '../helper/dialogs.dart';

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
    bool isMe = APIs.user.uid == widget.messages.fromid;

    return InkWell(
      onLongPress: () {
        _showBottonSheet(isMe);
      },
      child: isMe ? _myMessage() : _companionMessage(),
    );
  }

  Widget _myMessage() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      const SizedBox(
        width: 64.0,
      ),
      Flexible(
        child: Container(
          padding: EdgeInsets.all(
                  widget.messages.type == MessageType.text ? 12.0 : 0)
              .copyWith(
            bottom: 12.0,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
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
              widget.messages.type == MessageType.text
                  ? Text(
                      widget.messages.msg,
                      style: PalletTextStyles.bodyBig,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        width: 200,
                        imageUrl: widget.messages.msg,
                        placeholder: (context, url) => const ColoredBox(
                          color: PalletColors.cGrayField,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70.0,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.messages.type == MessageType.image
                      ? const SizedBox(
                          width: 12.0,
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  Text(
                    MyDateUtil.getFormattedTime(
                      context: context,
                      time: widget.messages.sent,
                    ),
                    style: PalletTextStyles.caption.copyWith(
                      color: PalletColors.cGrayText,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  if (widget.messages.read.isNotEmpty)
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

  Widget _companionMessage() {
    if (widget.messages.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.messages);
    }

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                    widget.messages.type == MessageType.text ? 12.0 : 0)
                .copyWith(
              bottom: 12.0,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white10,
              ),
              color: PalletColors.cGrayField,
              borderRadius:
                  const BorderRadius.all(Radius.circular(14)).copyWith(
                bottomLeft: const Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.messages.type == MessageType.text
                    ? Text(
                        widget.messages.msg,
                        style: PalletTextStyles.bodyBig,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          width: 200,
                          imageUrl: widget.messages.msg,
                          placeholder: (context, url) => const ColoredBox(
                            color: PalletColors.cGrayField,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 70.0,
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(
                    top: widget.messages.type == MessageType.image ? 12.0 : 0,
                    left: widget.messages.type == MessageType.image ? 12.0 : 0,
                  ),
                  child: Text(
                    MyDateUtil.getFormattedTime(
                      context: context,
                      time: widget.messages.sent,
                    ),
                    style: PalletTextStyles.caption.copyWith(
                      color: PalletColors.cGrayText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 64.0,
        )
      ],
    );
  }

  void _showBottonSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(
              20.0,
            ),
          ),
        ),
        builder: (_) {
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ).copyWith(
                bottom: 16.0,
              ),
              shrinkWrap: true,
              children: [
                Container(
                  height: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 146.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        14.0,
                      ),
                    ),
                    color: PalletColors.cGrayText,
                  ),
                ),
                widget.messages.type == MessageType.text
                    ? _OptionItem(
                        icon: const Icon(
                          Icons.copy,
                          size: 24.0,
                          color: PalletColors.cCyan600,
                        ),
                        lable: 'Copy Text',
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: widget.messages.msg,
                          )).then((value) {
                            Navigator.pop(context);
                            Dialogs.showConfirmSnackBar(
                              context,
                              'Text copied!',
                            );
                          });
                        })
                    : _OptionItem(
                        icon: const Icon(
                          Icons.download_for_offline_outlined,
                          size: 24.0,
                          color: PalletColors.cCyan600,
                        ),
                        lable: 'Save Image',
                        onTap: () async {
                          log(widget.messages.msg);
                          try {
                            await GallerySaver.saveImage(widget.messages.msg,
                                    albumName: 'IZIChat')
                                .then((success) {
                              Navigator.pop(context);
                              if (success != null && success) {
                                Dialogs.showConfirmSnackBar(
                                    context, 'Image dowloaded!');
                              }
                            });
                          } catch (e) {
                            log('Error saving image: $e');
                          }
                        }),
                const Divider(
                  color: PalletColors.cGrayField,
                  height: 4,
                ),
                if (widget.messages.type == MessageType.text && isMe)
                  _OptionItem(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 24.0,
                        color: PalletColors.cCyan600,
                      ),
                      lable: 'Edit Message',
                      onTap: () {
                        Navigator.pop(context);
                        _showMessageUpdateDialog();
                      }),
                if (isMe)
                  _OptionItem(
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        size: 24.0,
                        color: Colors.red,
                      ),
                      lable: 'Delete Image',
                      onTap: () async {
                        await APIs.dleteMessage(widget.messages).then((value) {
                          Navigator.pop(context);
                        });
                      }),
                if (isMe)
                  const Divider(
                    color: PalletColors.cGrayField,
                    height: 4,
                  ),
                _OptionItem(
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 24.0,
                      color: PalletColors.cCyan600,
                    ),
                    lable: 'Sent At:  ${MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.messages.sent,
                    )}',
                    onTap: () {}),
                _OptionItem(
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 24.0,
                      color: Colors.green,
                    ),
                    lable: widget.messages.read.isEmpty
                        ? 'Read At:  Not seen yet'
                        : 'Read At:  ${MyDateUtil.getLastMessageTime(
                            context: context,
                            time: widget.messages.read,
                          )}',
                    onTap: () {}),
              ],
            ),
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.messages.msg;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              title: Row(children: [
                const Icon(
                  Icons.message_outlined,
                  color: PalletColors.cCyan600,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Update message',
                  style: PalletTextStyles.bodySmall.copyWith(
                    color: PalletColors.cGrayText,
                  ),
                )
              ]),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                initialValue: updatedMsg,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: PalletTextStyles.titleMedium
                        .copyWith(color: Colors.red),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await APIs.updateMessage(widget.messages, updatedMsg);
                    if (!mounted)
                      return; // Checks `this.mounted`, not `context.mounted`.
                  },
                  child: Text(
                    'Save',
                    style: PalletTextStyles.titleMedium
                        .copyWith(color: PalletColors.cCyan600),
                  ),
                ),
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  const _OptionItem(
      {required this.icon, required this.lable, required this.onTap});

  final Icon icon;
  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 16.0,
            ),
            Flexible(
                child: Text(
              lable,
              style: PalletTextStyles.bodyMedium,
            )),
          ],
        ),
      ),
    );
  }
}
