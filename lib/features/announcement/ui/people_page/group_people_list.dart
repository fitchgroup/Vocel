import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/people_page/change_group_dialog.dart';
import 'package:vocel/features/announcement/ui/people_page/friend_profile_page.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key, this.showEdit, this.userEmail});
  final showEdit;
  final userEmail;
  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  List<String> desireList = ["leader", "parent", "staff"];
  late Future<List<String>> _futureResultLeader;
  late Future<List<String>> _futureResultParent;
  late Future<List<String>> _futureResultStaff;
  bool loading = false;


  /// get users in a specific group
  Future<List<String>> _getUserInTheList(String element) async {
    List<String> listElement = await getUserInTheList(element);
    return listElement;
  }
  Future<List<String>> getUserInTheList(String desireSingleList) async {
    Map<String, dynamic> listInGroup = await listUsersInGroup(desireSingleList);
    List<String> outputString = [];
    for(var userDict in listInGroup['Users']){
      for(var attributesDict in userDict['Attributes']){
        if(attributesDict["Name"] == "email"){
          outputString.add(attributesDict["Value"]);
        }
      }
    }
    return outputString;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
    _futureResultLeader = _getUserInTheList(desireList[0]);
    _futureResultParent = _getUserInTheList(desireList[1]);
    _futureResultStaff = _getUserInTheList(desireList[2]);
    loading = true;
  }

  Future<void> settingGroupStates() async {
    setState(() {
      loading = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = true;
    });
    List<String> leaderList = await _getUserInTheList(desireList[0]);
    List<String> staffList = await _getUserInTheList(desireList[2]);
    List<String> parentList = await _getUserInTheList(desireList[1]);

    setState(() {
      _futureResultLeader = Future<List<String>>.value(leaderList);
      _futureResultStaff = Future<List<String>>.value(staffList);
      _futureResultParent = Future<List<String>>.value(parentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? ListView(
        children: [
          Container(
            child: ExpansionTile(
              title: GroupTextWidget(text: desireList[0]),
              children: [
                SizedBox(
                  height: 200,
                  child: FutureBuilder<List<String>>(
                    future: _futureResultLeader,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<String> dataList = snapshot.data ?? [];
                        return Scrollbar(
                          child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(index.toString()),
                                direction: widget.showEdit ? DismissDirection.endToStart : DismissDirection.none,
                                confirmDismiss: (direction) async {
                                  if (direction == DismissDirection.endToStart && widget.showEdit) {
                                    // Show confirmation dialog for delete action
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChangeGroupDialog(
                                          currentGroup: desireList[0],
                                          currentUserEmail: dataList[index],
                                          onGroupChanged: () async {
                                            settingGroupStates();
                                          },
                                        );
                                      },
                                    );
                                  }
                                  return null;
                                },
                                background: peopleBackgroundContainer(),
                                child: peopleInkwell(context, widget.userEmail, dataList[index], desireList[0]),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Color(( constants.primaryDarkTeal.toInt() % 0xFF000000 + 0x66000000)),
          ),
          ExpansionTile(
            title: GroupTextWidget(text: desireList[2]),
            children: [
              SizedBox(
                height: 200,
                child: FutureBuilder<List<String>>(
                  future: _futureResultStaff,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<String> dataList = snapshot.data ?? [];
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(index.toString()),
                              direction: widget.showEdit ? DismissDirection.endToStart : DismissDirection.none,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  // Show confirmation dialog for delete action
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChangeGroupDialog(
                                        currentGroup: desireList[2],
                                        currentUserEmail: dataList[index],
                                        onGroupChanged: () async {
                                          settingGroupStates();
                                        },
                                      );
                                    },
                                  );
                                }
                                return null;
                              },
                              background: peopleBackgroundContainer(),
                              child: peopleInkwell(context, widget.userEmail, dataList[index], desireList[2]),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Divider(
            height: 0,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Color(( constants.primaryDarkTeal.toInt() % 0xFF000000 + 0x66000000)),
          ),
          ExpansionTile(
            title: GroupTextWidget(text: desireList[1]),
            children: [
              SizedBox(
                height: 200,
                child: FutureBuilder<List<String>>(
                  future: _futureResultParent,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<String> dataList = snapshot.data ?? [];
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(index.toString()),
                              direction: widget.showEdit ? DismissDirection.endToStart : DismissDirection.none,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  // Show confirmation dialog for delete action
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChangeGroupDialog(
                                        currentGroup: desireList[1],
                                        currentUserEmail: dataList[index],
                                        onGroupChanged: () async {
                                          settingGroupStates();
                                        },
                                      );
                                    },
                                  );
                                }
                                return null;
                              },
                              background: peopleBackgroundContainer(),
                              child: peopleInkwell(context, widget.userEmail, dataList[index], desireList[1]),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ) : const SpinKitFadingCircle(color: Color(constants.primaryDarkTeal)),
    );
  }
}

class GroupTextWidget extends StatelessWidget {
  final String text;

  const GroupTextWidget({
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
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black87,
                      letterSpacing: 2,
                      fontFamily: "Ysabeau",
                    ),
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
    color: const Color(constants.primaryDarkTeal).withOpacity(0.4), // Customize the background color for complete action
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
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

Widget peopleInkwell(BuildContext context, String myInfo, String theirEmail, String title) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute
        (builder: (context) =>
          // ChatPage(myInfo: myInfo, theirInfo: theirInfo, title: title),
          FriendProfile(name: 'testing name', region: 'testing region', email: theirEmail, title: title, aboutMe: 'dsa', myInfo: myInfo),
          settings: const RouteSettings(arguments: "")
      ));
      debuggingPrint("$myInfo is sending message to $theirEmail");
    },
    child: ListTile(
      title: Text(
        theirEmail,
        style: const TextStyle(
          letterSpacing: 0.5,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: title == "leader" ? const Color(constants.primaryDarkTeal) : title == "staff"
                                   ? const Color(constants.primaryRegularTeal) : const Color(constants.primaryLightTeal),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
          child: Text(
            title,
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
