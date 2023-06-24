import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:vocel/common/repository/auth_inject.dart';
import 'package:vocel/common/repository/auth_repository.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/simple_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:amplify_api/amplify_api.dart';
import './models/ModelProvider.dart'; // <--- Update import to reflect your project

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// TODO: LINK THE FIREBASE
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Might use later to override the translations based on a user's preferences
  // List? languages = await Devicelocale.preferredLanguages;
  // String? locale = await Devicelocale.currentLocale;

  /// Use the global `getIt` instance to register `AuthRepository`
  getIt.registerSingleton<AuthRepository>(configureAmplifySuccess());
  AuthRepository conf = configureAmplifySuccess();

  /// pass the conf to App() widget, creating
  /// loose coupling between App() and configureAmplifySuccess,
  /// which contains the amplifyconfiguration.dart
  conf.configureApp();

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
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
