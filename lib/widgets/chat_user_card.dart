import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izipizi_chat/models/chat_user.dart';
import 'package:izipizi_chat/screens/chat_screen.dart';
import 'package:izipizi_chat/utilits/pallets.dart';
import 'package:svg_flutter/svg.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    final double mqd = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 94,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 86,
            decoration: BoxDecoration(
              color: PalletColors.cBGContainer,
              border: Border.all(
                color: Colors.white10,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: widget.user.image != ''
                            ? CachedNetworkImage(
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: ColoredBox(
                                    color: PalletColors.cGrayField,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                        'assets/svgs/def_avatar.svg'),
                              )
                            : SvgPicture.asset('assets/svgs/def_avatar.svg'),
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
                              widget.user.name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: PalletTextStyles.titleBig,
                            ),
                          ),
                          Text(
                            widget.user.about,
                            style: PalletTextStyles.bodySmall
                                .copyWith(color: PalletColors.cGrayText),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '12:00',
                    style: PalletTextStyles.bodySmall
                        .copyWith(color: PalletColors.cCyan600),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: widget.user,
                  );
                },
                borderRadius: BorderRadius.circular(20.0),
                splashColor: PalletColors.cCyan600.withOpacity(.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
