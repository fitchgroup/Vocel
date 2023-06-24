import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/notification_util.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_hook.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_search.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  void onClickController(String change) {}

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Allow Notifications"),
                  content: const Row(
                    children: [
                      Icon(
                        Icons.notification_add_outlined,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 8),
                      // Add some spacing between the icon and text
                      Text(
                        "Vocel app would like to send you notifications",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Don\'t Allow',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) => Navigator.pop(context)),
                      child: const Text(
                        'Allow',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ));
      }
    });

    // AwesomeNotifications().createdStream.listen((notification) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Notification Created on ${notification.channelKey}')));
    // });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == "basic_channel" && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CalendarHook()),
          (route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatSearchBar(onClickController: onClickController),
        ElevatedButton(
          onPressed: () async {
            createVocelNotification();
            // NotificationSpecificTime? result = await pickSchedule(context);
            // if (result != null) {
            //   // Handle the selected schedule
            //   print('Selected day of the week: ${result.dayOfTheWeek}');
            //   print('Selected time of the day: ${result.timeOfDay}');
            //   scheduleVocelNotification(result);
            // } else {
            //   // Handle cancellation or no time selected
            //   print('No schedule selected.');
            // }
          },
          child: const Text('Pick Schedule'),
        ),
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
