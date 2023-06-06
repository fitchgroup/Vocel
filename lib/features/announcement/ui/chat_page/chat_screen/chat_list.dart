import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_search.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  void onClickController(String change) {

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatSearchBar(onClickController: onClickController),
        const Center(
          heightFactor: 3,
          // child: SpinKitCircle(
          //   size: 60,
          //   color: Color(constants.primaryColorDark),
          // )
        )
      ],
    );
  }
}
