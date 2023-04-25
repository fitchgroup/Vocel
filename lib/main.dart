import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:vocel/common/repository/auth_inject.dart';
import 'package:vocel/common/repository/auth_repository.dart';
import 'package:vocel/simple_app.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Might use later to override the translations based on a user's preferences
  // List? languages = await Devicelocale.preferredLanguages;
  // String? locale = await Devicelocale.currentLocale;

  // bool isAmplifySuccessfullyConfigured = false;
  // try {
  //   await _configureAmplify();
  //   isAmplifySuccessfullyConfigured = true;
  // } on AmplifyAlreadyConfiguredException {
  //   debugPrint('Amplify configuration failed.');
  // }


  /// Use the global `getIt` instance to register `AuthRepository`
  getIt.registerSingleton<AuthRepository>(configureAmplifySuccess());
  AuthRepository conf = configureAmplifySuccess();
  /// pass the conf to App() widget, creating
  /// loose coupling between App() and configureAmplifySuccess,
  /// which contains the amplifyconfiguration.dart
  conf.configureApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}