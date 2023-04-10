import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/announcements_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_list_page.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_list.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_screen.dart';

class AnnouncementsListPage extends StatefulWidget {
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
  State<AnnouncementsListPage> createState() => _AnnouncementsListPageState();
}

class _AnnouncementsListPageState extends State<AnnouncementsListPage> {

  int selectPageNumber = 0;

  Widget selectPage(int pageNumber){
    switch(pageNumber){
      case 0: return const Center(
        child: ChatScreen(),
      );
      case 1: return const Center(
        child: Text("People"),
      );
      case 2: return Center(
        child: CalendarListPage(),
      );
      default: return Center(
        child: CalendarListPage(),
      );
    }
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     print("set successfully");
      //     FocusScope.of(context).requestFocus(FocusNode());
      //     await showDatePicker(
      //       context: context,
      //       initialDate: DateTime.now(),
      //       firstDate: DateTime(DateTime.now().year),
      //       lastDate: DateTime(DateTime.now().year + 20),
      //     );
      //   },
      //   backgroundColor: const Color(constants.primaryColorDark),
      //   child: const Icon(Icons.add),
      // ),
      body: selectPage(selectPageNumber),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: const LocalizedButtonResolver().chats(context)
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.people),
                label: const LocalizedButtonResolver().people(context)
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
                label: const LocalizedButtonResolver().calendar(context)
            )
          ],
        currentIndex: selectPageNumber,
        selectedItemColor: const Color(constants.primaryLightTeal),
        onTap: (index) {
            setState(() {
              selectPageNumber = index;
            });
        },
      ),
    );
  }
}
