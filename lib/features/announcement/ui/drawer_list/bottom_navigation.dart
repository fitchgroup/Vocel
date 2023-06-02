import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_hook.dart';
import 'package:vocel/features/announcement/ui/drawer_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_list.dart';
import 'package:vocel/features/announcement/ui/home_page/announcement_list.dart';
import 'package:vocel/features/announcement/ui/people_page/group_people_list.dart';


class AnnouncementsListPage extends StatefulWidget {
  AnnouncementsListPage({
    super.key,
  });

  @override
  State<AnnouncementsListPage> createState() => _AnnouncementsListPageState(fetchGroups, addUserGroup, removeUserGroup, getUserAttributes);
}

class _AnnouncementsListPageState extends State<AnnouncementsListPage> {

  int selectPageNumber = 0;
  var currentGroup;
  final myKey = GlobalKey();
  bool showEdit = false;

  String? userEmail;
  final Future<List> Function() fetchGroups;
  final Future<void> Function(String) addUserGroup;
  final Future<void> Function(String) removeUserGroup;
  final Future<Map<String, String>> Function() getUserAttributes;

  _AnnouncementsListPageState(this.fetchGroups, this.addUserGroup, this.removeUserGroup, this.getUserAttributes);

  Future<void> _fetchAttributes() async {
    var userAttr = await getUserAttributes();
  }

  Future<void> _fetchAndPrintGroups() async {
    List groups = await fetchGroups();
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  Future<void> initializeState() async {
    Map<String, String> stringMap = await getUserAttributes();
    setState(() {
      userEmail = stringMap["email"];
    });

    bool value = await verifyAdminAccess();
    setState(() {
      showEdit = value;
    });
  }


  Widget selectPage(int pageNumber){
    switch(pageNumber){
      case 0: return const Center(
        child: AnnouncementHome(),
      );
      case 1: return const Center(
        child: ChatList(),
      );
      case 2: return Center(
        child: PeopleList(userEmail: userEmail, showEdit: showEdit),
      );
      case 3: return const Center(
        child: CalendarHook(),
      );
      default: return const Center(
        child: AnnouncementHome(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VocelNavigationDrawer(userEmail: userEmail),
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
      body: selectPage(selectPageNumber),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.announcement),
                label: const LocalizedButtonResolver().home(context)
            ),
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
        unselectedItemColor: Colors.grey.shade400,
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
