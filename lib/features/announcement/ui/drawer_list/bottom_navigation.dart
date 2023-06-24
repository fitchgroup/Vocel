import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_hook.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_page.dart';
import 'package:vocel/features/announcement/ui/drawer_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_list.dart';
import 'package:vocel/features/announcement/ui/home_page/home_list.dart';
import 'package:vocel/features/announcement/ui/people_page/group_people_list.dart';

class AnnouncementsListPage extends StatefulWidget {
  AnnouncementsListPage({
    super.key,
    // required this.adminEdit,
    // required this.userEmail,
  });

  // final adminEdit;
  // final userEmail;

  @override
  State<AnnouncementsListPage> createState() => _AnnouncementsListPageState(
      fetchGroups, addUserGroup, removeUserGroup, getUserAttributes);
}

class _AnnouncementsListPageState extends State<AnnouncementsListPage> {
  int selectPageNumber = 0;
  var currentGroup;
  final myKey = GlobalKey();

  final Future<List> Function() fetchGroups;
  final Future<void> Function(String) addUserGroup;
  final Future<void> Function(String) removeUserGroup;
  final Future<Map<String, String>> Function() getUserAttributes;
  String? myName;

  _AnnouncementsListPageState(this.fetchGroups, this.addUserGroup,
      this.removeUserGroup, this.getUserAttributes);

  /// ////////////////////////////////////////////////////////////// ///
  /// -------------------------------------------------------------- ///
  /// ----------------TODO: GET USERS PERMISSION ------------------- ///
  /// -------------------------------------------------------------- ///
  /// ////////////////////////////////////////////////////////////// ///
  bool adminEdit = false;
  String groupEdit = "";
  String? userEmail;

  Future<void> getUserStatus() async {
    Map<String, String> stringMap = await getUserAttributes();
    setState(() {
      userEmail = stringMap["email"];
    });

    String checkGroup = await verifyGroupAccess();
    bool value = (checkGroup == "Staffversion1");
    setState(() {
      adminEdit = value;
      groupEdit = checkGroup;
    });

    for (var entry in stringMap.entries) {
      if (entry.key == "custom:name") {
        setState(() {
          myName = entry.value;
        });
      } else {
        continue;
      }
    }
  }

  /// ////////////////////////////////////////////////////////////// ///
  /// -------------------------------------------------------------- ///
  /// ----------------TODO: GET USERS FROM BACKEND ----------------- ///
  /// -------------------------------------------------------------- ///
  /// ////////////////////////////////////////////////////////////// ///

  List<String> desireList = [
    "Staffversion1",
    "Bellversion1",
    "Eetcversion1",
    "Vcpaversion1"
  ];

  // Declare futureResult with a default value
  late Future<List<dynamic>> futureResult = Future.value([]);
  bool loading = false;

  /// get users in a specific group or all groups
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
        if (kDebugMode) {
          print("${attributeName}and$attributeValue");
        }

        if (desiredAttributes.contains(attributeName)) {
          if (attributeName == "email") {
            outputMap["email"] = attributeValue;
            Map<String, dynamic> jsonMap =
                await listGroupsForUser(receivedUserName: attributeValue);

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
    List<Map<String, String>> allUserList = await _getUserAttrInTheMap("");
    setState(() {
      futureResult = Future<List<Map<String, String>>>.value(allUserList);
    });
    setState(() {
      loading = true;
    });
  }

  /// ////////////////////////////////////////////////////////////// ///
  /// -------------------------------------------------------------- ///
  /// ----------------TODO: PUSH NOTIFICATION TO VOCEL ------------- ///
  /// -------------------------------------------------------------- ///
  /// ////////////////////////////////////////////////////////////// ///

  @override
  void initState() {
    super.initState();
    initialize();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Allow Notifications"),
                  content: const Row(
                    children: [
                      Icon(
                        Icons.notification_add_outlined,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 8),
                      // Add some spacing between the icon and text
                      Text(
                        "Vocel app would like to send you notifications",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Don\'t Allow',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) => Navigator.pop(context)),
                      child: const Text(
                        'Allow',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ));
      }
    });
    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == "basic_channel" && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CalendarHook()),
          (route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  Future<void> initialize() async {
    await getUserStatus();
    setState(() {
      loading = false;
      if (adminEdit == true) {
        futureResult = _getUserAttrInTheMap("");
      } else {
        if (['Staffversion1', 'Bellversion1', 'Eetcversion1', 'Vcpaversion1']
            .contains(groupEdit)) {
          futureResult = _getUserAttrInTheMap(groupEdit);
        } else {
          futureResult = Future.value([]);
        }
      }
    });
    setState(() {
      loading = true;
    });
    if (kDebugMode) {
      print(
          "${"=" * 100}loading user done in lib/features/announcement/ui/drawer_list${"=" * 100}");
    }
  }

  String switching = "Announcement";

  Widget selectPage(int pageNumber) {
    switch (pageNumber) {
      case 0:
        return switching == "Announcement"
            ? Center(
                child: HomeAnnouncementFeed(
                showEdit: adminEdit,
                onClickController: (String value) {
                  setState(() {
                    switching = value;
                    if (kDebugMode) {
                      print('${"=" * 100}\n$switching${"=" * 100}\n');
                    }
                  });
                },
              ))
            : Center(
                child: ForumPage(
                  showEdit: adminEdit,
                  userEmail: userEmail!,
                  groupOfUser: groupEdit,
                  myName: myName ?? "",
                  onClickController: (String value) {
                    setState(() {
                      switching = value;
                      if (kDebugMode) {
                        print('${"=" * 100}\n$switching${"=" * 100}\n');
                      }
                    });
                  },
                ),
              );
      case 1:
        return const Center(
          child: ChatList(),
        );
      case 2:
        return Center(
          child: PeopleList(
              userEmail: userEmail,
              showEdit: adminEdit,
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
            child: HomeAnnouncementFeed(
          showEdit: adminEdit,
          onClickController: (String value) {
            setState(() {
              switching = value;
            });
          },
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VocelNavigationDrawer(userEmail: userEmail, showEdit: adminEdit),
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
