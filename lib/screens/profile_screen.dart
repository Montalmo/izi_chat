import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:svg_flutter/svg.dart';

import '../api/api.dart';
import '../screens/auth/login_screen.dart';
import '../utilits/pallets.dart';
import '../models/chat_user.dart';
import '../helper/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? currentImage;

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    final currentChatUser =
        ModalRoute.of(context)!.settings.arguments as ChatUser;

    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  currentImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.file(
                              File(currentImage as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: currentChatUser.image != ''
                              ? CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  width: 120,
                                  height: 120,
                                  imageUrl: currentChatUser.image,
                                  placeholder: (context, url) =>
                                      const ColoredBox(
                                    color: PalletColors.cGrayField,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                          'assets/svgs/def_avatar.svg'),
                                )
                              : SvgPicture.asset('assets/svgs/def_avatar.svg'),
                        ),
                  IconButton.filled(
                    onPressed: () {
                      showBottomSheet();
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                currentChatUser.email,
                textAlign: TextAlign.center,
                style: PalletTextStyles.bodyMedium.copyWith(
                  color: PalletColors.cGrayText,
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 24.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onSaved: (value) => APIs.me.name = value ?? '',
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Required field',
                        initialValue: currentChatUser.name,
                        decoration: const InputDecoration(
                          labelText: 'Your name',
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        onSaved: (value) => APIs.me.about = value ?? '',
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Required field',
                        initialValue: currentChatUser.about,
                        decoration: const InputDecoration(
                          labelText: 'Somethig about me',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            APIs.updateUserInfo().then(
                              (value) => Dialogs.showConfirmSnackBar(
                                  context, 'Profile updated successfully!'),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Update'),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red.shade400,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              });
              if (context.mounted) {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.0), topRight: Radius.circular(14.0)),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 16,
            ),
            children: [
              const Text(
                'Pick profile picture',
                style: PalletTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? photo = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                      );
                      if (photo != null) {
                        setState(() {
                          currentImage = photo.path;
                        });
                        APIs.updateProfilePicture(File(currentImage!));
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      }
                    },
                    icon: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset('assets/images/camera_icon.png')),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (image != null) {
                        setState(() {
                          currentImage = image.path;
                        });
                        APIs.updateProfilePicture(File(currentImage!));

                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      }
                    },
                    icon: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset('assets/images/file_pic_icon.png')),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
