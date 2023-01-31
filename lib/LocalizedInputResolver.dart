import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizedInputResolver extends InputResolver {
  const LocalizedInputResolver();

  /// Label of sign in form button
  /* @override
  String email(BuildContext context) {
    return AppLocalizations.of(context)!.email;
  }*/

  @override
  String title(BuildContext context, InputField field) {
    if (field.name == "password") {
      return AppLocalizations.of(context)!.password;
    } else if (field.name.contains("passwordConfirmation")) {
      return AppLocalizations.of(context)!
          .confirmAttribute(AppLocalizations.of(context)!.password);
    }

    return super.title(context, field);
  }
}
