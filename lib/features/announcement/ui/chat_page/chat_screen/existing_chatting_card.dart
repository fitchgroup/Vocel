import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_box.dart';
import 'package:flutter/material.dart';

class ExistingChattingCard extends StatefulWidget {
  final String otherPersonName;
  final String latestMessageContent;
  final String myInfo;
  final DateTime time;

  // final String avatarKey;
  // final String avatarUrl;

  const ExistingChattingCard({
    Key? key,
    required this.otherPersonName,
    required this.latestMessageContent,
    required this.myInfo,
    required this.time,
    // required this.avatarKey,
    // required this.avatarUrl,
  }) : super(key: key);

  @override
  State<ExistingChattingCard> createState() => _ExistingChattingCardState();
}

class _ExistingChattingCardState extends State<ExistingChattingCard> {
  String? avatarKey;
  String? avatarUrl;

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

  Future<void> getCurrentUserAttribute(String currentUser) async {
    Map<String, dynamic> jsonMap =
        await getCustomUserAttribute(username: currentUser);

    for (var element in jsonMap["UserAttributes"]) {
      if (element['Name'] == 'custom:avatarUrl') {
        setState(() {
          avatarUrl = element['Value'];
        });
      }
      if (element['Name'] == 'custom:avatarKey') {
        setState(() {
          avatarKey = element['Value'];
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getCurrentUserAttribute(widget.otherPersonName);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: (avatarUrl != "" && avatarUrl != null
            ? CachedNetworkImageProvider(
                avatarUrl!,
                cacheKey: avatarKey,
              )
            : const AssetImage('images/vocel_logo.png')
                as ImageProvider<Object>),
        radius: 30.0,
      ),
      title: Text(
        widget.otherPersonName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.latestMessageContent,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(displayTime(widget.time)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    myInfo: widget.myInfo,
                    theirInfo: widget.otherPersonName,
                    title: ""),
                settings: const RouteSettings(arguments: "")));
      },
    );
  }
}
