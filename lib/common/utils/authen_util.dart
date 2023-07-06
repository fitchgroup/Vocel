import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

Future<void> checkSigningIn() async {
  // v1
  final session = await Amplify.Auth.getPlugin(
    AmplifyAuthCognito.pluginKey,
  ).fetchAuthSession();
  
  try {
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();
    authUtilPrint('accessToken: $accessToken');
  } on SignedOutException catch (e) {
    authUtilPrint(e.toString());
  } on SessionExpiredException catch (e) {
    authUtilPrint(e.toString());
  } on NetworkException catch (e) {
    authUtilPrint(e.toString());
  }

  final identityId = session.identityIdResult.valueOrNull;
  authUtilPrint('identityId: $identityId');
}

void authUtilPrint(String needPrint) {
  if (kDebugMode) {
    print("*" * 50 + "authUtilPrint" + "*" * 50 + '\n');
    print(needPrint);
    print("*" * 50 + "authUtilPrint" + "*" * 50 + '\n');
  }
}
