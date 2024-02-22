import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:izipizi_chat/helper/my_date_util.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  static const String routeName = '/view_profile_screen';

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileOwner = ModalRoute.of(context)!.settings.arguments as ChatUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(profileOwner.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                  imageUrl: profileOwner.image,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                profileOwner.email,
                style: PalletTextStyles.bodyMedium
                    .copyWith(color: PalletColors.cGrayText),
              ),
              const SizedBox(height: 12.0),
              Text(
                profileOwner.about,
                style: PalletTextStyles.bodyBig,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Joined on: ',
            style: PalletTextStyles.bodyMedium
                .copyWith(color: PalletColors.cCyan600),
          ),
          Text(
            MyDateUtil.getLastMessageTime(
              context: context,
              time: profileOwner.createAt,
              showYear: true,
            ),
            style: PalletTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
