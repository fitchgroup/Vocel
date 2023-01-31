import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizedTitleResolver extends TitleResolver {
  const LocalizedTitleResolver();

  /// Label of sign in form button
  @override
  String signIn(BuildContext context) {
    return AppLocalizations.of(context)!.signIn;
  }

  @override
  String signUp(BuildContext context) {
    return AppLocalizations.of(context)!.signUp;
  }
}
