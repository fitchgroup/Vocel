import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:vocel/models/Announcement.dart';

void myFunctionToGracefullyDegradeMyApp([BuildContext? context]) async {
  // Show a dialog to inform the user about the limited functionality without push notifications
  if (context != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Push Notification Permissions Required'),
          content: const Text(
              'Push notification permissions are required for certain app features.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

Future<void> myFunctionExplainingPermissionsRequest(
    [BuildContext? context]) async {
  // Show an explanatory dialog to the user about the push notification permissions request
  if (context != null) {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Allow Push Notifications'),
          content: const Text(
              'To receive important updates and notifications, please grant permission for push notifications.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

void handlePermissions(BuildContext context) async {
  final status = await Amplify.Notifications.Push.getPermissionStatus();
  if (status == PushNotificationPermissionStatus.granted) {
    // no further action is required, user has already granted permissions
    return;
  }
  if (status == PushNotificationPermissionStatus.denied) {
    // further attempts to request permissions will no longer do anything
    myFunctionToGracefullyDegradeMyApp(context);
    return;
  }
  if (status == PushNotificationPermissionStatus.shouldRequest) {
    // go ahead and request permissions from the user
    await Amplify.Notifications.Push.requestPermissions();
    return;
  }
  if (status == PushNotificationPermissionStatus.shouldExplainThenRequest) {
    // you should display some explanation to your user before requesting permissions
    await myFunctionExplainingPermissionsRequest(context);
    // then request permissions
    await Amplify.Notifications.Push.requestPermissions();
    return;
  }
}

void myTokenReceivedHandler(String token) {
  // Do something with the received token
}

void cancel() async {
  final subscription =
      Amplify.Notifications.Push.onTokenReceived.listen(myTokenReceivedHandler);

// Remember to cancel the subscription when it is no longer needed
  subscription.cancel();
}

Future<void> identifyTheUserToAmazonPinpoint() async {
  final user = await Amplify.Auth.getCurrentUser();
  const userProfile = UserProfile(
    email: "pyang33@illinois.edu",
  );

  await Amplify.Notifications.Push.identifyUser(
    userId: user.userId,
    userProfile: userProfile,
  );
}

Future<int> getTheCurrentBadgeCount() async =>
    await Amplify.Notifications.Push.getBadgeCount();

void updateTheBadgeCount(int badgeCount) =>
    Amplify.Notifications.Push.setBadgeCount(badgeCount);

/// -----------------------------------------------------------------------
/// -----------------------------------------------------------------------
/// -----------------------------------------------------------------------
/// -----------third party library: awesome_notification-------------------
/// -----------------------------------------------------------------------
/// -----------------------------------------------------------------------
/// -----------------------------------------------------------------------

/// Parameters of the NotificationContent class:
// - id (required): Unique identifier for the notification. It is used to identify and update the notification later.
// - channelKey (required): The channel key associated with the notification. It determines which channel the notification belongs to.
// - title (required): The title text of the notification.
// - body (optional): The body text of the notification.
// - summary (optional): The summary text of the notification, usually displayed as a brief preview or additional information.
// - bigPicture (optional): An image URL or file path to be displayed as the main content of the notification.
// - notificationLayout (optional): The layout style of the notification. It accepts values from the NotificationLayout enum, such as NotificationLayout.Default, NotificationLayout.BigPicture, NotificationLayout.BigText, etc.
// - autoCancel (optional): Specifies whether the notification should be automatically canceled when the user taps on it. It is a boolean value (true or false).
// - payload (optional): Additional data or payload associated with the notification. It can be any custom data you want to include.
// - color (optional): The color to be applied to the notification. It can be specified as a hexadecimal color value (e.g., 0xFF00FF00).
// - showWhen (optional): Specifies whether the notification should display the time at which it was posted. It is a boolean value (true or false).
// - showProgress (optional): Specifies whether a progress bar should be displayed in the notification. It is a boolean value (true or false).
// - progress (optional): The current progress value for the progress bar, ranging from 0 to 100.

int createUniqueId({String? possibleId}) {
  return DateTime.now().millisecondsSinceEpoch.remainder(10000);
}

Future<void> createVocelNotification({String? possibleId}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'I need money ${Emojis.money_money_bag}',
        body: 'Hello, this is a test reminder 2',
        bigPicture: 'resource://drawable/app_logo',
        // this one will work
        notificationLayout: NotificationLayout.BigPicture,
        showWhen: true,
        autoCancel: true),
  );
}

Future<void> scheduleSpecificVocelNotification(
    NotificationSpecificDateTime notificationSchedule,
    Announcement currentAnnouncement) async {
  DateTime specificDateTime = notificationSchedule.specificDateTime;
  TimeOfDay timeOfDay = notificationSchedule.timeOfDay;

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: currentAnnouncement.tripName,
        body: "currentAnnouncement.description + ${Emojis.animals_panda * 100}",
        notificationLayout: NotificationLayout.Default,
        showWhen: true,
        autoCancel: true),
    schedule: NotificationCalendar(
        year: specificDateTime.year,
        month: specificDateTime.month,
        day: specificDateTime.day,
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: false),
  );
}

class NotificationSpecificDateTime {
  final DateTime specificDateTime;
  final TimeOfDay timeOfDay;

  NotificationSpecificDateTime({
    required this.specificDateTime,
    required this.timeOfDay,
  });
}

Future<void> scheduleVocelNotification(
    NotificationSpecificTime notificationSchedule,
    {String? possibleId}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'scheduled_channel',
          title: 'This is scheduled ${Emojis.animals_panda}',
          body: 'testing schedule',
          notificationLayout: NotificationLayout.Default,
          showWhen: true,
          autoCancel: true),
      schedule: NotificationCalendar(
          weekday: notificationSchedule.dayOfTheWeek,
          hour: notificationSchedule.timeOfDay.hour,
          minute: notificationSchedule.timeOfDay.minute,
          second: 0,
          millisecond: 0,
          repeats: false));
}

class NotificationSpecificTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationSpecificTime(
      {required this.dayOfTheWeek, required this.timeOfDay});
}

Future<NotificationSpecificTime?> pickSchedule(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime != null) {
    // TimePicker dialog closed with a selected time
    return NotificationSpecificTime(
      dayOfTheWeek: DateTime.now().weekday,
      timeOfDay: pickedTime,
    );
  } else {
    // TimePicker dialog closed without selecting a time
    return null;
  }
}

Future<void> cancelScheduledNotification() async {
  await AwesomeNotifications().cancelAllSchedules();
}
