import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/people_page/change_group_dialog.dart';
import 'package:vocel/features/announcement/ui/people_page/friend_profile_page.dart';
import 'package:vocel/features/announcement/ui/people_page/user_search_bar.dart';

class PeopleList extends StatefulWidget {
  const PeopleList(
      {super.key,
      this.showEdit,
      this.userEmail,
      required this.loading,
      required this.futureResult,
      required this.callback});

  final showEdit;
  final userEmail;
  final loading;
  final futureResult;
  final callback;

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String searching = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.loading
          ? Column(
              children: [
                UserSearchBar(
                  onClickController: (String value) {
                    setState(() {
                      searching = value;
                    });
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: widget.futureResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        /// TODO: change the implementation if error raised in fetching data
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map<String, String>> dataList =
                            snapshot.data ?? [];

                        /// TODO: SORT THE LIST BASED ON EMAIL, MAY CHANGE IN THE FUTURE
                        dataList
                            .sort((a, b) => a["email"]!.compareTo(b["email"]!));
                        return ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            bool visibilityCheck = dataList[index]["email"]!
                                    .toUpperCase()
                                    .contains(searching.toUpperCase()) ||
                                (dataList[index]["VocelGroup"] == null
                                    ? false
                                    : dataList[index]["VocelGroup"]!
                                        .toUpperCase()
                                        .contains(searching.toUpperCase()));
                            return Column(
                              children: [
                                Visibility(
                                  visible: visibilityCheck,
                                  child: Dismissible(
                                    key: Key(index.toString()),
                                    direction: widget.showEdit
                                        ? DismissDirection.endToStart
                                        : DismissDirection.none,
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                              DismissDirection.endToStart &&
                                          widget.showEdit) {
                                        // Show confirmation dialog for delete action
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ChangeGroupDialog(
                                              currentGroup: dataList[index]
                                                      ["VocelGroup"] ??
                                                  "Unassigned",
                                              currentUserEmail: dataList[index]
                                                      ["email"] ??
                                                  "...",
                                              onGroupChanged: () async {
                                                widget.callback();
                                              },
                                            );
                                          },
                                        );
                                      }
                                      return null;
                                    },
                                    background: peopleBackgroundContainer(),
                                    child: peopleInkwell(
                                        context,
                                        widget.userEmail,
                                        dataList[index]["email"] ?? "",
                                        dataList[index]["name"] ?? "",
                                        dataList[index]["region"] ?? "",
                                        dataList[index]["aboutMe"] ?? "",
                                        dataList[index]["VocelGroup"] ??
                                            "Unassigned"),
                                  ),
                                ),
                                Visibility(
                                    visible: visibilityCheck,
                                    child: peopleListDivider()),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          : const SpinKitFadingCircle(color: Color(constants.primaryDarkTeal)),
    );
  }
}

class GroupTextWidget extends StatelessWidget {
  final String text;

  const GroupTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey[200]!.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 30,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black87,
                    letterSpacing: 2,
                    fontFamily: "Ysabeau",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget peopleBackgroundContainer() {
  return Container(
    color: const Color(constants.primaryDarkTeal).withOpacity(0.4),
    // Customize the background color for complete action
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        Text(
          "Edit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget peopleInkwell(BuildContext context, String myInfo, String theirEmail,
    String theirName, String theirRegion, String theirAboutMe, String title) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FriendProfile(
                  name: theirName,
                  region: theirRegion,
                  email: theirEmail,
                  title: title,
                  aboutMe: theirAboutMe,
                  myInfo: myInfo),
              settings: const RouteSettings(arguments: "")));
      // debuggingPrint("$myInfo is sending message to $theirEmail");
    },
    child: ListTile(
      leading: const CircleAvatar(
        // Specify your avatar properties here
        radius: 18,
        backgroundImage: AssetImage(
            'images/vocel_logo.png'), // Replace with your avatar image
      ),
      title: Text(
        theirEmail,
        style: const TextStyle(
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: title == "Staffversion1"
              ? const Color(constants.primaryDarkTeal)
              : (title == "Bellversion1" ||
                      title == "Eetcversion1" ||
                      title == "Vcpaversion1")
                  ? const Color(constants.primaryRegularTeal)
                  : Colors.grey[350],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
          child: Text(
            ["Staffversion1", "Bellversion1", "Eetcversion1", "Vcpaversion1"]
                    .contains(title)
                ? title.substring(0, title.indexOf("version")).toUpperCase()
                : title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget peopleListDivider() => Divider(
      height: 0,
      thickness: 0.3,
      indent: 10,
      endIndent: 10,
      color:
          Color((constants.primaryDarkTeal.toInt() % 0xFF000000 + 0x66000000)),
    );
