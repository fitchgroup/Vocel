import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/mutation/models_subscription.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_hook.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_page.dart';
import 'package:vocel/features/announcement/ui/drawer_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_list.dart';
import 'package:vocel/features/announcement/ui/home_page/home_page.dart';
import 'package:vocel/features/announcement/ui/people_page/group_people_list.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

class AnnouncementsListPage extends StatefulWidget {
  AnnouncementsListPage({
    super.key,
    required this.isAmplifySuccessfullyConfigured,
  });

  final isAmplifySuccessfullyConfigured;

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
  SubscriptionStatus prevSubscriptionStatus = SubscriptionStatus.disconnected;

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
  String? avatarKey;
  String? avatarUrl;

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
      } else if (entry.key == "custom:avatarkey") {
        setState(() {
          avatarKey = entry.value;
        });
      } else if (entry.key == "custom:avatarurl") {
        setState(() {
          avatarUrl = entry.value;
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

  // Declare futureResult with a default value
  late Future<List<dynamic>> futureResult = Future.value([]);
  bool loading = false;

  /// get users in a specific group or all groups
  Future<List<Map<String, String>>> _getUserAttrInTheMap(String element) async {
    List<Map<String, String>> mapElement;
    if (element == "") {
      mapElement = [];
      for (String iterElement in desireGroupList) {
        List<Map<String, String>> tempMapElement = [];
        tempMapElement = await getUserAttrInTheMap(iterElement);
        mapElement.addAll(tempMapElement);
      }
      List<Map<String, String>> mapElementWithAllUsers =
          await getUserAttrInTheMap("");
      List<String?> listMapElement =
          mapElement.map((item) => item["email"]).toList();
      List<Map<String, String>> result = mapElementWithAllUsers
          .where((item) => !listMapElement.contains(item["email"]))
          .toList();
      mapElement.addAll(result);
    } else {
      mapElement = await getUserAttrInTheMap(element);
      List<Map<String, String>> mapStaffElement =
          await getUserAttrInTheMap("Staffversion1");
      mapElement.addAll(mapStaffElement);
    }
    return mapElement;
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
    // Amplify.Hub.listen(
    //   HubChannel.Api,
    //   (ApiHubEvent event) {
    //     if (event is SubscriptionHubEvent) {
    //       if (prevSubscriptionStatus == SubscriptionStatus.connecting &&
    //           event.status == SubscriptionStatus.connected) {}
    //       prevSubscriptionStatus = event.status;
    //     }
    //   },
    // );
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
                      Wrap(
                        children: [
                          Text(
                            "Vocel app would like to send you notifications",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
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
    // // AwesomeNotifications().createdStream.listen((notification) {
    // //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // //       content: Text('Notification Created on ${notification.channelKey}')));
    // // });
    // AwesomeNotifications().actionStream.listen((notification) {
    //   if (notification.channelKey == "basic_channel" && Platform.isIOS) {
    //     AwesomeNotifications().getGlobalBadgeCounter().then(
    //           (value) =>
    //               AwesomeNotifications().setGlobalBadgeCounter(value - 1),
    //         );
    //   }
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (_) => const CalendarHook()),
    //       (route) => route.isFirst);
    // });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This condition ensures we only run our async operations once.
    if (subscriptionVocelEvent == null) {
      subscribeVocelEvent();
    }
    if (subscriptionPost == null) {
      subscribePost();
    }
    if (subscriptionAnnouncement == null) {
      subscribeAnnouncement();
    }
  }

  Future<void> initialize() async {
    await getUserStatus();
    if (subscriptionVocelMessage == null) {
      subscribeVocelMessage(userEmail!);
    }
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
    // ElevatedButton(
    //   onPressed: () async {
    //     createVocelNotification();
    //     // NotificationSpecificTime? result = await pickSchedule(context);
    //     // if (result != null) {
    //     //   // Handle the selected schedule
    //     //   print('Selected day of the week: ${result.dayOfTheWeek}');
    //     //   print('Selected time of the day: ${result.timeOfDay}');
    //     //   scheduleVocelNotification(result);
    //     // } else {
    //     //   // Handle cancellation or no time selected
    //     //   print('No schedule selected.');
    //     // }
    //   },
    //   child: const Text('Pick Schedule'),
    // ),
    switch (pageNumber) {
      case 0:
        return switching == "Announcement"
            ? Center(
                child: HomeAnnouncementFeed(
                showEdit: adminEdit,
                userEmail: userEmail ?? "",
                groupOfUser: groupEdit,
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
                  userEmail: userEmail ?? "",
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
        return Center(
          child: ChatList(
            myInfo: userEmail,
            // futureResult: futureResult,
          ),
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
          userEmail: userEmail ?? "",
          groupOfUser: groupEdit,
          onClickController: (String value) {
            setState(() {
              switching = value;
              if (kDebugMode) {
                print('${"=" * 100}\n$switching${"=" * 100}\n');
              }
            });
          },
        ));
    }
  }

  String displayTitle(int number) {
    String titleString;
    switch (number) {
      case 0:
        titleString = "Vocel";
        break;
      case 1:
        titleString = LocalizedButtonResolver().chats(context);
        break;
      case 2:
        titleString = LocalizedButtonResolver().people(context);
        break;
      case 3:
        titleString = LocalizedButtonResolver().calendar(context);
        break;
      default:
        titleString = LocalizedButtonResolver().home(context);
        break;
    }
    return titleString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VocelNavigationDrawer(
          userEmail: userEmail,
          showEdit: adminEdit,
          groupOfUser: groupEdit,
          avatarKey: avatarKey,
          avatarUrl: avatarUrl),
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
        title: Text(displayTitle(selectPageNumber)),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: widget.isAmplifySuccessfullyConfigured
          ? selectPage(selectPageNumber)
          : const Center(
              child: Text(
              'Tried to reconfigure Amplify; '
              'this can occur when your app restarts on Android.',
            )),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: const LocalizedButtonResolver().home(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat_rounded),
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
