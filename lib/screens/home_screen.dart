import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izipizi_chat/models/chat_user.dart';
import 'package:izipizi_chat/screens/profile_screen.dart';
import 'package:izipizi_chat/utilits/pallets.dart';
import 'package:izipizi_chat/widgets/chat_user_card.dart';

import '../api/api.dart';
import '../helper/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<ChatUser> chatUsers;
  List<ChatUser> searchUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.updateActiveStatus(true);

    if (APIs.auth.currentUser != null) {
      SystemChannels.lifecycle.setMessageHandler((message) {
        log('Message: $message');

        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('inactive')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('detached')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        return Future.value(message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: _isSearching ? false : true,
        onPopInvoked: (didPop) {
          setState(() {
            _isSearching = !_isSearching;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            leading: _isSearching
                ? null
                : const Icon(
                    Icons.home_outlined,
                    color: PalletColors.cCyan600,
                  ),
            title: _isSearching
                ? TextField(
                    controller: _controller,
                    //searching logic
                    onChanged: (val) {
                      //search logic
                      searchUsers.clear();
                      for (var i in chatUsers) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          searchUsers.add(i);
                          setState(() {
                            searchUsers;
                          });
                        }
                      }
                    },
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            14.0,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
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
                    ),
                  )
                : const Text('IZIChat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _controller.clear();
                      searchUsers.clear();
                    }
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching ? Icons.clear_rounded : Icons.search_sharp,
                  color: _isSearching
                      ? PalletColors.cCyan600
                      : PalletColors.cWhite,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ProfileScreen.routeName,
                    arguments: APIs.me,
                  );
                },
                icon: const Icon(Icons.more_vert_sharp),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            chatUsers = data
                                    ?.map(
                                      (e) => ChatUser.fromJson(
                                        e.data(),
                                      ),
                                    )
                                    .toList() ??
                                [];

                            return chatUsers.isNotEmpty
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: _isSearching
                                        ? searchUsers.length
                                        : chatUsers.length,
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                        user: _isSearching
                                            ? searchUsers[index]
                                            : chatUsers[index],
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'Your chat list is empty',
                                      style: PalletTextStyles.bodyBig.copyWith(
                                          color: PalletColors.cCyan600),
                                    ),
                                  );
                        }
                      });
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showMessageDialog();
            },
            child: const Icon(Icons.add_comment_outlined),
          ),
        ),
      ),
    );
  }

  void _showMessageDialog() {
    String email = '';

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
        title: Row(
          children: [
            const Icon(
              Icons.add_reaction_outlined,
              size: 16.0,
              color: PalletColors.cCyan600,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Text('Add user by Email',
                style: PalletTextStyles.bodySmall
                    .copyWith(color: PalletColors.cGrayText)),
          ],
        ),
        content: TextFormField(
          maxLines: 1,
          onChanged: (value) => email = value,
          decoration: const InputDecoration(
              hintText: 'Users Email',
              hintStyle: TextStyle(color: PalletColors.cGrayText)),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: PalletTextStyles.titleMedium.copyWith(color: Colors.red),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showErrorSnackBar(context, 'User does not Exists');
                  }
                });
              }
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: Text(
              "Add",
              style: PalletTextStyles.titleMedium.copyWith(
                color: PalletColors.cCyan600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// StreamBuilder(
//               stream: APIs.getAllUsers(),
//               builder: (context, snapshot) {
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                   case ConnectionState.none:
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );

//                   case ConnectionState.active:
//                   case ConnectionState.done:
//                     final data = snapshot.data?.docs;

//                     chatUsers = data
//                             ?.map(
//                               (e) => ChatUser.fromJson(
//                                 e.data(),
//                               ),
//                             )
//                             .toList() ??
//                         [];

//                     return chatUsers.isNotEmpty
//                         ? ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                             ),
//                             itemCount: _isSearching
//                                 ? searchUsers.length
//                                 : chatUsers.length,
//                             itemBuilder: (context, index) {
//                               return ChatUserCard(
//                                 user: _isSearching
//                                     ? searchUsers[index]
//                                     : chatUsers[index],
//                               );
//                             },
//                           )
//                         : Center(
//                             child: Text(
//                               'Your chat list is empty',
//                               style: PalletTextStyles.bodyBig
//                                   .copyWith(color: PalletColors.cCyan600),
//                             ),
//                           );
//                 }
//               }),
