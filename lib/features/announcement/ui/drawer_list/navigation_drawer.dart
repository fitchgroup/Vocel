import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/drawer_list/navigation_item.dart';
import 'package:vocel/features/announcement/ui/profile_page/profile.dart';
import 'package:vocel/features/announcement/ui/setting_page/setting_page.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/features/announcement/ui/event_list/event_page.dart';

class VocelNavigationDrawer extends StatefulWidget {
  final String? userEmail;
  final bool showEdit;
  final groupOfUser;

  const VocelNavigationDrawer(
      {super.key,
      this.userEmail,
      required this.showEdit,
      required this.groupOfUser});

  @override
  State<VocelNavigationDrawer> createState() => _VocelNavigationDrawerState();
}

class _VocelNavigationDrawerState extends State<VocelNavigationDrawer> {
  String? userEmail;
  String? myName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAttributesFromBackend().then((value) => null);
  }

  Future<void> getUserAttributesFromBackend() async {
    Map<String, String> stringMap = await getUserAttributes();
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: const Color(constants.primaryColorDark),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  color: const Color(constants.primaryColorDark),
                  child: VocelAvator(context, widget.userEmail)),
              const SizedBox(
                height: 6,
              ),
              NavigationItem(
                  name: const LocalizedButtonResolver().profile(context),
                  leadingIcon: Icons.account_circle,
                  onPressedFunction: () => itemPressed(context,
                      index: 0, userEmail: widget.userEmail, myName: myName)),
              const SizedBox(
                height: 6,
              ),
              NavigationItem(
                  name: const LocalizedButtonResolver().events(context),
                  leadingIcon: Icons.event,
                  onPressedFunction: () => itemPressed(context,
                      index: 1,
                      showEdit: widget.showEdit,
                      groupOfUser: widget.groupOfUser)),
              const SizedBox(
                height: 6,
              ),
              // NavigationItem(
              //     name:
              //         const LocalizedButtonResolver().discussionForum(context),
              //     leadingIcon: Icons.post_add,
              //     onPressedFunction: () => itemPressed(context,
              //         index: 2,
              //         showEdit: widget.showEdit,
              //         userEmail: widget.userEmail,
              //         myName: myName)),
              // const SizedBox(
              //   height: 6,
              // ),
              Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 10,
                color: Color((constants.primaryColorDark.toInt() % 0xFF000000 +
                    0x66000000)),
              ),
              NavigationItem(
                  name: const LocalizedButtonResolver().settings(context),
                  leadingIcon: Icons.settings,
                  onPressedFunction: () => itemPressed(context, index: 4)),
              const SizedBox(
                height: 6,
              ),
              // NavigationItem(
              //     name: const LocalizedButtonResolver().helps(context),
              //     leadingIcon: Icons.help_outline,
              //     onPressedFunction: ()=> itemPressed(context, index:5)
              // ),
              // const SizedBox(height: 6,),
            ],
          ),
        ),
      ),
    ));
  }
}

itemPressed(BuildContext context,
    {required int index,
    String? userEmail,
    bool? showEdit,
    String? myName,
    String? groupOfUser}) {
  Navigator.pop(context);
  switch (index) {
    case 0:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VocelProfile(userEmail: userEmail, myName: myName),
              settings: const RouteSettings(arguments: "settings page")));
      break;
    case 1:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(
                    showEdit: showEdit ?? false,
                    groupOfUser: groupOfUser,
                  ),
              settings: const RouteSettings(arguments: "settings page")));
      break;
    // case 2:
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => ForumPage(
    //               showEdit: showEdit ?? false,
    //               userEmail: userEmail!,
    //               myName: myName ?? ""),
    //           settings: const RouteSettings(arguments: "settings page")));
    //   break;
    // case 3:
    //   Navigator.push(context, MaterialPageRoute(
    //       builder: (context) =>
    //           const PeopleList(),
    //       settings: const RouteSettings(arguments: "settings page")));
    //   break;
    case 4:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VocelSetting(),
              settings: const RouteSettings(arguments: "settings page")));
      break;

    /// TODO: delete HELP page for now, may add in the future
    // case 5:
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => ContactPage(),
    //     settings: const RouteSettings(arguments: "settings page")));
    // break;
    default:
      Navigator.pop(context);
      break;
  }
}

Widget VocelAvator(BuildContext context, String? userEmail) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 50, 0, 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                // decoration: const Bo,
                child: Image.asset("images/vocel_logo.png")),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(userEmail ?? const LocalizedButtonResolver().email(context),
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ],
        )
      ],
    ),
  );
}
