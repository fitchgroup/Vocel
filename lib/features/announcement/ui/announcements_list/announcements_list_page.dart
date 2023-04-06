import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/announcements_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      drawer: const VocelNavigationDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.vocelMobileApp
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("set successfully");
          FocusScope.of(context).requestFocus(FocusNode());
          await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 20),
          );
        },
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Announcements'),
      ),
    );
  }
}
