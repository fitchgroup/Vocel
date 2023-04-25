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

  @override
  String email(BuildContext context){
    return AppLocalizations.of(context)!.email;
  }

  @override
  String profile(BuildContext context){
    return AppLocalizations.of(context)!.profile;
  }

  @override
  String events(BuildContext context){
    return AppLocalizations.of(context)!.events;
  }

  @override
  String chats(BuildContext context){
    return AppLocalizations.of(context)!.chats;
  }

  @override
  String calendar(BuildContext context){
    return AppLocalizations.of(context)!.calendar;
  }

  @override
  String discussionForum(BuildContext context){
    return AppLocalizations.of(context)!.discussionForum;
  }

  @override
  String settings(BuildContext context){
    return AppLocalizations.of(context)!.settings;
  }

  @override
  String support(BuildContext context){
    return AppLocalizations.of(context)!.support;
  }

  @override
  String notifications(BuildContext context){
    return AppLocalizations.of(context)!.notifications;
  }

  @override
  String helps(BuildContext context){
    return AppLocalizations.of(context)!.helps;
  }

  @override
  String people(BuildContext context){
    return AppLocalizations.of(context)!.people;
  }

  @override
  String reminder(BuildContext context){
    return AppLocalizations.of(context)!.reminder;
  }

  @override
  String announcement(BuildContext context){
    return AppLocalizations.of(context)!.announcement;
  }

  @override
  String home(BuildContext context){
    return AppLocalizations.of(context)!.home;
  }

  @override
  String signOut(BuildContext context){
    return AppLocalizations.of(context)!.signOut;
  }
}
