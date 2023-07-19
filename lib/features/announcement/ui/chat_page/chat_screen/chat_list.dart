import 'package:flutter/material.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_search.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/existing_chat_list.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
    required this.myInfo,
    // required this.futureResult,
  }) : super(key: key);

  final myInfo;

  // final futureResult;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  void onClickController(String change) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String searching = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatSearchBar(onClickController: (String value) {
          setState(() {
            searching = value;
          });
        }),
        Expanded(
            child: ExistingChatList(
          myInfo: widget.myInfo,
          // futureResult: widget.futureResult,
          searching: searching,
          indicator: false,
        ))
      ],
    );
  }
}
