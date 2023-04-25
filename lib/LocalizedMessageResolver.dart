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

  @override
  String languages(BuildContext context){
    return AppLocalizations.of(context)!.language;
  }

  @override
  String shareOnSocialMedia(BuildContext context){
    return AppLocalizations.of(context)!.shareOnSocialMedia;
  }

  @override
  String registerForEvent(BuildContext context){
    return AppLocalizations.of(context)!.registerForEvent;
  }

  @override
  String accountSettings(BuildContext context){
    return AppLocalizations.of(context)!.accountSettings;
  }

  @override
  String eventDetail(BuildContext context){
    return AppLocalizations.of(context)!.eventDetail;
  }

  @override
  String eventDescription(BuildContext context){
    return AppLocalizations.of(context)!.eventDescription;
  }

  @override
  String contactForm(BuildContext context){
    return AppLocalizations.of(context)!.contactForm;
  }

  @override
  String getInTouch(BuildContext context){
    return AppLocalizations.of(context)!.getInTouch;
  }

  @override
  String message(BuildContext context){
    return AppLocalizations.of(context)!.message;
  }

  @override
  String contactInfo(BuildContext context){
    return AppLocalizations.of(context)!.contactInfo;
  }

  @override
  String myAccount(BuildContext context){
    return AppLocalizations.of(context)!.myAccount;
  }

  @override
  String profile(BuildContext context){
    return AppLocalizations.of(context)!.profile;
  }

  @override
  String name(BuildContext context){
    return AppLocalizations.of(context)!.name;
  }

  @override
  String phoneNumber(BuildContext context){
    return AppLocalizations.of(context)!.phoneNumber;
  }

  @override
  String address(BuildContext context){
    return AppLocalizations.of(context)!.address;
  }

}
