import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedInputResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/LocalizedTitleResolver.dart';
import 'package:vocel/amplifyconfiguration.dart';
import 'package:vocel/features/announcement/ui/announcements_list/announcements_list_page.dart';
import 'package:vocel/common/repository/auth_inject.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale changedLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(changedLocale);
  }

}

class _MyAppState extends State<MyApp> {
  Locale? _local;


  changeLocale(Locale currentLocale){
    setState(() {
      _local = currentLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    // configureApp();
  }

  // Future<String> configureApp() async {
  //   // TODO: implement configureApp
  //   try {
  //     await Amplify.addPlugin(AmplifyAuthCognito());
  //     await Amplify.configure(amplifyconfig);
  //     // setState(() {
  //     //   isAmplifySuccessfullyConfigured = true;
  //     // });
  //     return "Successfully configured";
  //   } on Exception catch (e) {
  //     debugPrint('${"="*50}\nError configuring Amplify: $e\n${"="*50}');
  //     return 'Error configuring Amplify: $e';
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    const stringResolver = AuthStringResolver(
        buttons: LocalizedButtonResolver(),
        inputs: LocalizedInputResolver(),
        titles: LocalizedTitleResolver(),
        messages: LocalizedMessageResolver());

    return Authenticator(
      stringResolver: stringResolver,
      child: MaterialApp(
        // ignore: prefer_const_literals_to_create_immutables
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        locale: _local,
        builder: Authenticator.builder(),
        home: AnnouncementsListPage(),
      ),
    );
  }
}



// reference to change the language based on language on platform
// https://stackoverflow.com/questions/50923906/how-to-get-timezone-language-and-county-id-in-flutter-by-the-location-of-device