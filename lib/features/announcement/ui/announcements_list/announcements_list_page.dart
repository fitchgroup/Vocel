import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class AnnouncementsListPage extends StatelessWidget {
  AnnouncementsListPage({
    super.key,
  }) {
    fetchGroups();
  }

  Future<List> fetchGroups() async {
    List groups = List.filled(0, 0);
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String accessToken = ((result as CognitoAuthSession).userPoolTokens)!
          .accessToken; //.idToken;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      groups = decodedToken["cognito:groups"];
    } on AuthException catch (e) {
      safePrint(e.message);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Vocel Mobile App',
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Announcements'),
      ),
    );
  }
}
