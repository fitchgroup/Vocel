import 'package:intl/intl.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_box.dart';
import 'package:vocel/models/ModelProvider.dart';
import 'package:flutter/material.dart';

class ExistingChattingCard extends StatelessWidget {
  final String otherPersonName;
  final String latestMessageContent;
  final List<VocelMessage> messages;
  final String myInfo;

  const ExistingChattingCard({
    Key? key,
    required this.otherPersonName,
    required this.latestMessageContent,
    required this.messages,
    required this.myInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('images/vocel_logo.png'),
        radius: 30.0,
      ),
      title: Text(
        otherPersonName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        latestMessageContent,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        DateFormat('hh:mm a').format(
            messages.last.updatedAt?.getDateTimeInUtc() ??
                messages.last.createdAt!.getDateTimeInUtc()),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    myInfo: myInfo, theirInfo: otherPersonName, title: ""),
                settings: const RouteSettings(arguments: "")));
      },
    );
  }
}