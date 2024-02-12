import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: currentChatUser.image != ''
                        ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            width: 120,
                            height: 120,
                            imageUrl: currentChatUser.image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset('assets/svgs/def_avatar.svg'),
                          )
                        : SvgPicture.asset('assets/svgs/def_avatar.svg'),
                  ),
                  IconButton.filled(
                    onPressed: () {},
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
}
