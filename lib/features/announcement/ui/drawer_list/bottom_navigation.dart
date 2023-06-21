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
  State<AnnouncementsListPage> createState() => _AnnouncementsListPageState(
      fetchGroups, addUserGroup, removeUserGroup, getUserAttributes);
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

  _AnnouncementsListPageState(this.fetchGroups, this.addUserGroup,
      this.removeUserGroup, this.getUserAttributes);

  Future<void> getUserStatus() async {
    Map<String, String> stringMap = await getUserAttributes();
    setState(() {
      userEmail = stringMap["email"];
    });

    bool value = await verifyAdminAccess();
    setState(() {
      showEdit = value;
    });
  }

  /// ////////////////////////////////////////////////////////////// ///
  /// -------------------------------------------------------------- ///
  /// ----------------TODO: GET USERS FROM BACKEND------------------ ///
  /// -------------------------------------------------------------- ///
  /// ////////////////////////////////////////////////////////////// ///

  List<String> desireList = [
    "Staffversion1",
    "Bellversion1",
    "Eetcversion1",
    "Vcpaversion1"
  ];
  late Future<List<Map<String, String>>> futureResult;
  bool loading = false;

  /// get users in a specific group
  Future<List<Map<String, String>>> _getUserAttrInTheMap(String element) async {
    List<Map<String, String>> mapElement;
    if (element == "") {
      mapElement = await getUserAttrInTheMap("");
    } else {
      mapElement = await getUserAttrInTheMap(element);
    }
    return mapElement;
  }

  Future<List<Map<String, String>>> getUserAttrInTheMap(
      String desireSingleList) async {
    Map<String, dynamic> listInGroup;

    List<Map<String, String>> outputList = [];

    Set<String> desiredAttributes = {
      "email",
      "custom:name",
      "custom:about",
      "custom:region",
    };

    if (desireSingleList == "") {
      listInGroup = await listAllUsersInGroup();
    } else {
      listInGroup = await listUsersInGroup(desireSingleList);
    }

    for (var userDict in listInGroup['Users']) {
      Map<String, String> outputMap = {};

      for (var attributesDict in userDict['Attributes']) {
        String attributeName = attributesDict["Name"];
        String attributeValue = attributesDict["Value"].toString();

        if (desiredAttributes.contains(attributeName)) {
          if (attributeName == "email") {
            outputMap["email"] = attributeValue;
            Map<String, dynamic> jsonMap =
                await listGroupsForUser(receivedUserName: attributeValue);
            jsonMap.forEach((key, value) {
              manageUserDebuggingPrint("$attributeValue + $key + $value");
            });
            for (var element in jsonMap["Groups"]) {
              if (!outputMap.containsKey("VocelGroup") &&
                  desireList.contains(element["GroupName"])) {
                outputMap["VocelGroup"] = element["GroupName"];
              }
            }
          } else if (attributeName == "custom:name") {
            outputMap["name"] = attributeValue;
          } else if (attributeName == "custom:about") {
            outputMap["aboutMe"] = attributeValue;
          } else if (attributeName == "custom:region") {
            outputMap["region"] = attributeValue;
          }
        }
      }

      if (outputMap.isNotEmpty) {
        outputList.add(outputMap);
      }
    }

    return outputList;
  }

  Future<void> settingGroupStates() async {
    setState(() {
      loading = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = true;
    });
    List<Map<String, String>> allUserList = await _getUserAttrInTheMap("");

    setState(() {
      futureResult = Future<List<Map<String, String>>>.value(allUserList);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserStatus();
    loading = false;
    futureResult = _getUserAttrInTheMap("");
    loading = true;
  }

  Widget selectPage(int pageNumber) {
    switch (pageNumber) {
      case 0:
        return Center(
          child: AnnouncementHome(showEdit: showEdit),
        );
      case 1:
        return const Center(
          child: ChatList(),
        );
      case 2:
        return Center(
          child: PeopleList(
              userEmail: userEmail,
              showEdit: showEdit,
              loading: loading,
              futureResult: futureResult,
              callback: settingGroupStates),
        );
      case 3:
        return const Center(
          child: CalendarHook(),
        );
      default:
        return Center(
          child: AnnouncementHome(showEdit: showEdit),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VocelNavigationDrawer(userEmail: userEmail, showEdit: showEdit),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.vocelMobileApp),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: selectPage(selectPageNumber),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.announcement),
              label: const LocalizedButtonResolver().home(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: const LocalizedButtonResolver().chats(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.people),
              label: const LocalizedButtonResolver().people(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month),
              label: const LocalizedButtonResolver().calendar(context))
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
