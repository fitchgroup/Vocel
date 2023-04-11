import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizedMessageResolver extends MessageResolver {
  const LocalizedMessageResolver();

  /// Label of sign in form button
  //@override
  //String signIn(BuildContext context) {
  //  return AppLocalizations.of(context)!.signin;
  //}

  @override
  String vocelAppLanguageChanges(BuildContext context){
    return AppLocalizations.of(context)!.vocelAppLanguageChanges;
  }

  @override
  String confirm(BuildContext context){
    return AppLocalizations.of(context)!.confirm;
  }

  @override
  String notices(BuildContext context){
    return AppLocalizations.of(context)!.notices;
  }
}
