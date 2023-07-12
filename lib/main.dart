import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:vocel/common/repository/auth_inject.dart';
import 'package:vocel/common/repository/auth_repository.dart';
import 'package:vocel/simple_app.dart'; // <--- Update import to reflect your project

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Might use later to override the translations based on a user's preferences
  // List? languages = await Devicelocale.preferredLanguages;
  // String? locale = await Devicelocale.currentLocale;
  bool isAmplifySuccessfullyConfigured = false;
  try {
    /// Use the global `getIt` instance to register `AuthRepository`
    getIt.registerSingleton<AuthRepository>(configureAmplifySuccess());
    AuthRepository conf = configureAmplifySuccess();

    /// pass the conf to App() widget, creating
    /// loose coupling between App() and configureAmplifySuccess,
    /// which contains the amplifyconfiguration.dart
    String returnMessage = await conf.configureApp();
    debugPrint("${"==" * 100} \n $returnMessage \n ${"==" * 100}");
    isAmplifySuccessfullyConfigured = true;
  } on AmplifyAlreadyConfiguredException {
    debugPrint(
        "${"==" * 100} \n Amplify configuration failed \n ${"==" * 100}");
  }

  AwesomeNotifications().initialize(
    'resource://drawable/app_logo',
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'basic notification',
          channelDescription: 'basic test',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          enableVibration: true),
      NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Schedule Notification',
          channelDescription: 'basic test 2',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          enableVibration: true),
    ],
    // debug: true
  );

  runApp(
    ProviderScope(
      child: MyApp(
          isAmplifySuccessfullyConfigured: isAmplifySuccessfullyConfigured),
    ),
  );
}
