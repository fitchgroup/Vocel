import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/cupertino.dart';
import 'package:vocel/common/repository/auth_repository.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:vocel/models/ModelProvider.dart';
// import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';

// Note: This handler does not *need* to be async, but it can be!
Future<void> myAsyncNotificationReceivedHandler(
    PushNotificationMessage notification) async {
  /// TODO: implement myAsyncNotificationReceivedHandler
  // Process the received push notification message in the background\

  return;
}

class configureAmplifySuccess extends AuthRepository {
  @override
  Future<String> configureApp() async {
    // TODO: implement configureApp
    try {
      // // notification plugin
      // final notificationsPlugin = AmplifyPushNotificationsPinpoint();
      //
      // // Should be added in the main function to avoid missing events.
      // notificationsPlugin.onNotificationReceivedInBackground(
      //     myAsyncNotificationReceivedHandler);

      // api plugin
      final apiPlugin = AmplifyAPI(
        modelProvider: ModelProvider.instance,
        // Optional config
        subscriptionOptions: const GraphQLSubscriptionOptions(
          retryOptions: RetryOptions(maxAttempts: 10),
        ),
      );
      // Configure the desired API name

      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        apiPlugin,
        AmplifyStorageS3()
        // notificationsPlugin,
      ]);

      const String amplifyConfig = String.fromEnvironment('VERSION');
      await Amplify.configure(amplifyConfig);
      return "Successfully configured";
    } on Exception catch (e) {
      debugPrint('${"=" * 50}\nError configuring Amplify: $e\n${"=" * 50}');
      return 'Error configuring Amplify: $e';
    }
  }
}
