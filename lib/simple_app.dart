import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedInputResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/LocalizedTitleResolver.dart';
import 'package:vocel/common/utils/language_constants.dart';
import 'package:vocel/features/announcement/ui/announcements_list/announcements_list_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale changedLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?. changeLocale(changedLocale);
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
  }

  @override
  void didChangeDependencies(){
    // keep language when refresh, this should be needed
    // not sure why the app works without this
    /// BUG:
    /// Context of a state is available to us from the moment the State loads its dependencies.
    /// At the time build is called, context is available to us and is passed as an argument.
    /** initstate is called before the state loads its dependencies and for that reason no
     context is available and you get an error for that if you use context in initstate.
     However, didChangeDependencies is called just a few moments after the state loads its
     dependencies and context is available at this moment so here you can use context **/

    /** However both of them are called before build is called. The only difference is that
     one is called before the state loads its dependencies and the other is called a few
     moments after the state loads its dependencies. **/

    getLocale().then((locale) => setLocale(locale.languageCode));
    super.didChangeDependencies();

  }


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