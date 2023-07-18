import 'package:intl/intl.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_box.dart';
import 'package:flutter/material.dart';

class ExistingChattingCard extends StatelessWidget {
  final String otherPersonName;
  final String latestMessageContent;
  final String myInfo;
  final DateTime time;

  const ExistingChattingCard({
    Key? key,
    required this.otherPersonName,
    required this.latestMessageContent,
    required this.myInfo,
    required this.time,
  }) : super(key: key);

  String displayTime(DateTime time) {
    if (time.year == DateTime.now().toLocal().year) {
      if (time.month == DateTime.now().toLocal().month &&
          time.day == DateTime.now().toLocal().day) {
        return DateFormat('HH:mm').format(time);
      } else {
        return DateFormat("MM/dd").format(time);
      }
    } else {
      return DateFormat("MMMM dd, yyyy").format(time);
    }
  }

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
      trailing: Text(displayTime(time)),
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
