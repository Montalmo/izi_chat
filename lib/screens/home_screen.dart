import 'package:flutter/material.dart';
import 'package:izipizi_chat/models/chat_user.dart';
import 'package:izipizi_chat/screens/profile_screen.dart';
import 'package:izipizi_chat/utilits/pallets.dart';
import 'package:izipizi_chat/widgets/chat_user_card.dart';

import '../api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> chatUsers = [];
  final List<ChatUser> searchUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? null
            : const Icon(
                Icons.home_outlined,
                color: PalletColors.cCyan600,
              ),
        title: _isSearching
            ? const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true
                ),
              )
            : const Text('IZIChat'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(
              _isSearching ? Icons.clear_rounded : Icons.search_sharp,
              color: _isSearching ? PalletColors.cCyan600 : PalletColors.cWhite,
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
          stream: APIs.getAllUsers(),
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

                List chatUsers = data
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
                        itemCount: chatUsers.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: chatUsers[index],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Your chat list is empty',
                          style: PalletTextStyles.bodyBig
                              .copyWith(color: PalletColors.cCyan600),
                        ),
                      );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_comment_outlined),
      ),
    );
  }
}
