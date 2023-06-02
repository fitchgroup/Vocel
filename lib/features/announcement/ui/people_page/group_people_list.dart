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
  late Future<List<Map<String, String>>> _futureResultLeader;
  late Future<List<Map<String, String>>> _futureResultParent;
  late Future<List<Map<String, String>>> _futureResultStaff;
  bool loading = false;


  /// get users in a specific group
  Future<List<Map<String, String>>> _getUserAttrInTheMap(String element) async {
    List<Map<String, String>> mapElement = await getUserAttrInTheMap(element);
    return mapElement;
  }
  Future<List<Map<String, String>>> getUserAttrInTheMap(String desireSingleList) async {
    Map<String, dynamic> listInGroup = await listUsersInGroup(desireSingleList);
    List<Map<String, String>> outputList = [];
    for(var userDict in listInGroup['Users']){
      debuggingPrint(userDict.toString());
      Map<String, String> outputMap = {};
      for(var attributesDict in userDict['Attributes']){
        if(attributesDict["Name"] == "email" ||
            attributesDict["Name"] == "custom:name" ||
            attributesDict["Name"] == "custom:about" ||
            attributesDict["Name"] == "custom:region"){
          if(attributesDict["Name"] == "email"){
            outputMap["email"] = attributesDict["Value"].toString();
          }
          else if(attributesDict["Name"] == "custom:name"){
            outputMap["name"] = attributesDict["Value"].toString();
          }
          else if(attributesDict["Name"] == "custom:about"){
            outputMap["aboutMe"] = attributesDict["Value"].toString();
          }
          else {
            outputMap["region"] = attributesDict["Value"].toString();
          }

        }
      }
      if(outputMap.isNotEmpty) {
        outputList.add(outputMap);
      }
      debuggingPrint(outputMap.toString());
    }
    return outputList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
    _futureResultLeader = _getUserAttrInTheMap(desireList[0]);
    _futureResultParent = _getUserAttrInTheMap(desireList[1]);
    _futureResultStaff = _getUserAttrInTheMap(desireList[2]);
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
    List<Map<String, String>> leaderList = await _getUserAttrInTheMap(desireList[0]);
    List<Map<String, String>> staffList = await _getUserAttrInTheMap(desireList[2]);
    List<Map<String, String>> parentList = await _getUserAttrInTheMap(desireList[1]);

    setState(() {
      _futureResultLeader = Future<List<Map<String, String>>>.value(leaderList);
      _futureResultStaff = Future<List<Map<String, String>>>.value(staffList);
      _futureResultParent = Future<List<Map<String, String>>>.value(parentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
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
                  List<Map<String, String>> dataList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Dismissible(
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
                                      currentUserEmail: dataList[index]["email"] ?? "...",
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
                            child: peopleInkwell(context, widget.userEmail, dataList[index]["email"] ?? "...", desireList[0]),
                          ),
                          peopleListDivider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
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
                  List<Map<String, String>> dataList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Dismissible(
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
                                      currentUserEmail: dataList[index]["email"] ?? "...",
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
                            child: peopleInkwell(context, widget.userEmail, dataList[index]["email"] ?? "...", desireList[2]),
                          ),
                          peopleListDivider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
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
                  List<Map<String, String>> dataList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Dismissible(
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
                                      currentUserEmail: dataList[index]["email"] ?? "...",
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
                            child: peopleInkwell(context, widget.userEmail, dataList[index]["email"] ?? "...", desireList[1]),
                          ),
                          peopleListDivider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
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

Widget peopleListDivider() => Divider(
  height: 0,
  thickness: 0.2,
  indent: 10,
  endIndent: 10,
  color: Color(( constants.primaryDarkTeal.toInt() % 0xFF000000 + 0x66000000)),
);