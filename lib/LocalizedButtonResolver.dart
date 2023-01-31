import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizedButtonResolver extends ButtonResolver {
  const LocalizedButtonResolver();

  /// Label of sign in form button
  @override
  String signIn(BuildContext context) {
    return AppLocalizations.of(context)!.signIn;
  }

  @override
  String signUp(BuildContext context) {
    return AppLocalizations.of(context)!.signUp;
  }

  @override
  String forgotPassword(BuildContext context) {
    return AppLocalizations.of(context)!.forgotPassword;
  }
}
