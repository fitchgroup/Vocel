import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

// import 'package:vocel/common/repository/auth_inject.dart';
// import 'package:vocel/common/repository/auth_repository.dart';
import 'package:vocel/models/ModelProvider.dart';
import 'package:vocel/simple_app.dart'; // <--- Update import to reflect your project
import 'package:amplify_api/amplify_api.dart';
import 'amplifyconfiguration.dart';

final getIt = GetIt.instance;

Future<String> _configureApp() async {
  try {
    // // notification plugin
    // final notificationsPlugin = AmplifyPushNotificationsPinpoint();
    //
    // // Should be added in the main function to avoid missing events.
    // notificationsPlugin.onNotificationReceivedInBackground(
    //     myAsyncNotificationReceivedHandler);

    if (!Amplify.isConfigured) {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(
          modelProvider: ModelProvider.instance,
          // Optional config
          subscriptionOptions: const GraphQLSubscriptionOptions(
            retryOptions: RetryOptions(maxAttempts: 5),
          ),
        ),
        AmplifyStorageS3(),
        // notificationsPlugin,
      ]);

      // const String amplifyConfig = String.fromEnvironment('VERSION');
      await Amplify.configure(amplifyconfig);
      return "Successfully configured";
    } else {
      return "Amplify is already configured";
    }
  } on Exception catch (e) {
    return 'Error configuring Amplify: $e\n';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Might use later to override the translations based on a user's preferences
  // List? languages = await Devicelocale.preferredLanguages;
  // String? locale = await Devicelocale.currentLocale;
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

  bool isAmplifySuccessfullyConfigured = false;
  try {
    /// Use the global `getIt` instance to register `AuthRepository`
    //  getIt.registerSingleton<AuthRepository>(configureAmplifySuccess());
    // AuthRepository conf = configureAmplifySuccess();

    /// pass the conf to App() widget, creating
    /// loose coupling between App() and configureAmplifySuccess,
    /// which contains the amplifyconfiguration.dart
    // String e = await conf.configureApp();

    String e = await _configureApp();
    debugPrint(
        "${"==" * 100} \n Amplify configuration succeeded: $e \n ${"==" * 100}");
    isAmplifySuccessfullyConfigured = true;
  } on AmplifyAlreadyConfiguredException {
    debugPrint(
        "${"==" * 100} \n Amplify configuration failed \n ${"==" * 100}");
  }

  runApp(
    ProviderScope(
      child: MyApp(
          isAmplifySuccessfullyConfigured: isAmplifySuccessfullyConfigured),
    ),
  );
}
