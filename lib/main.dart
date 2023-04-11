import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocel/simple_app.dart';
// import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Might use later to override the translations based on a user's preferences
  List? languages = await Devicelocale.preferredLanguages;
  String? locale = await Devicelocale.currentLocale;

  bool isAmplifySuccessfullyConfigured = false;
  try {
    await _configureAmplify();
    isAmplifySuccessfullyConfigured = true;
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }

  runApp(
    ProviderScope(
      child: MyApp(
        isAmplifySuccessfullyConfigured: isAmplifySuccessfullyConfigured,
      ),
    ),
  );
}

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
  ]);
  // await Amplify.configure(amplifyconfig);
}
