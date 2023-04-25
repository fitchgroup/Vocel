import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
// import 'package:vocel/amplifyconfiguration.dart';
import 'package:vocel/common/repository/auth_repository.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:vocel/model/ModelProvider.dart';

class configureAmplifySuccess extends AuthRepository {
  @override
  Future<String> configureApp() async {
    // TODO: implement configureApp
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        // AmplifyDataStore(modelProvider: ModelProvider.instance),
        // AmplifyAPI(),
      ]);
      const String amplifyConfig = String.fromEnvironment('VERSION');
      await Amplify.configure(amplifyConfig);
      return "Successfully configured";
    } on Exception catch (e) {
      debugPrint('${"="*50}\nError configuring Amplify: $e\n${"="*50}');
      return 'Error configuring Amplify: $e';
    }
  }
}