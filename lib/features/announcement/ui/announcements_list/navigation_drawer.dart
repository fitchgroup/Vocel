import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/announcements_list/navigation_item.dart';
import 'package:vocel/features/announcement/ui/announcements_list/profile.dart';
import 'package:vocel/features/announcement/ui/announcements_list/setting_page.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
class VocelNavigationDrawer extends StatelessWidget {
  const VocelNavigationDrawer({Key? key}) : super(key: key);

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
                      child: VocelAvator(context)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().profile(context),
                      leadingIcon: Icons.account_circle,
                      onPressedFunction: ()=> itemPressed(context, index:0)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().events(context),
                      leadingIcon: Icons.event,
                      onPressedFunction: ()=> itemPressed(context, index:1)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().discussionForum(context),
                      leadingIcon: Icons.post_add,
                      onPressedFunction: ()=> itemPressed(context, index:2)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().support(context),
                      leadingIcon: Icons.notification_add_rounded,
                      onPressedFunction: ()=> itemPressed(context, index:3)
                  ),
                  const SizedBox(height: 6,),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 10,
                    color: Color(( constants.primaryColorDark.toInt() % 0xFF000000 + 0x66000000)),
                  ),
                  NavigationItem(
                      name: const LocalizedButtonResolver().settings(context),
                      leadingIcon: Icons.settings,
                      onPressedFunction: ()=> itemPressed(context, index:4)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().notifications(context),
                      leadingIcon: Icons.notification_add_rounded,
                      onPressedFunction: ()=> itemPressed(context, index:5)
                  ),
                  const SizedBox(height: 6,),
                  NavigationItem(
                      name: const LocalizedButtonResolver().helps(context),
                      leadingIcon: Icons.settings,
                      onPressedFunction: ()=> itemPressed(context, index:6)
                  ),
                  const SizedBox(height: 6,),
                ],
            ),
          ),
        ),
      )
    );
  }
}

itemPressed(BuildContext context, {required int index}) {
  Navigator.pop(context);
  switch(index){
    case 0:
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
          const VocelProfile(),
          settings: const RouteSettings(arguments: "settings page")));
      break;
    case 1:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelProfile(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    case 2:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelProfile(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    case 3:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelProfile(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    case 4:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelSetting(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    case 5:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelProfile(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    case 6:
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
        const VocelProfile(),
        settings: const RouteSettings(arguments: "settings page")));
    break;
    default:
      Navigator.pop(context);
      break;
  }
}

Widget VocelAvator(BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 50, 0, 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle
            ),
            // decoration: const Bo,
            child: Image.asset("images/social-white-900x900.png")
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(const LocalizedButtonResolver().email(context), style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
        )
      ],
    ),
  );

}
