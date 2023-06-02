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
  /// DEPRECIATED:
  // late Future<List<Map<String, String>>> _futureResultLeader;
  // late Future<List<Map<String, String>>> _futureResultParent;
  // late Future<List<Map<String, String>>> _futureResultStaff;
  late Future<List<Map<String, String>>> _futureResult;
  bool loading = false;


  /// get users in a specific group
  Future<List<Map<String, String>>> _getUserAttrInTheMap(String element) async {
    List<Map<String, String>> mapElement;
    if(element == ""){
      mapElement = await getUserAttrInTheMap("");
    }
    else {
      mapElement = await getUserAttrInTheMap(element);
    }
    return mapElement;
  }
  Future<List<Map<String, String>>> getUserAttrInTheMap(String desireSingleList) async {
    Map<String, dynamic> listInGroup;
    if(desireSingleList == ""){
      listInGroup = await listAllUsersInGroup();
    }
    else {
      listInGroup = await listUsersInGroup(desireSingleList);
    }
    List<Map<String, String>> outputList = [];
    for(var userDict in listInGroup['Users']){
      Map<String, String> outputMap = {};
      for(var attributesDict in userDict['Attributes']){
        if(attributesDict["Name"] == "email" ||
            attributesDict["Name"] == "custom:name" ||
            attributesDict["Name"] == "custom:about" ||
            attributesDict["Name"] == "custom:region"){
          if(attributesDict["Name"] == "email"){
            outputMap["email"] = attributesDict["Value"].toString();
            Map<String, dynamic> jsonMap = await listGroupsForUser(receivedUserName: outputMap["email"]);
            jsonMap.forEach((key, value) {
              debuggingPrint("${outputMap["email"]} + $key + $value");
            });
            for (var element in jsonMap["Groups"]) {
              if(!outputMap.containsKey("VocelGroup") && ["leader", "parent", "staff"].contains(element["GroupName"])){
                outputMap["VocelGroup"] = element["GroupName"];
              }
            }
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
    }
    return outputList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
    _futureResult = _getUserAttrInTheMap("");
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
    List<Map<String, String>> allUserList = await _getUserAttrInTheMap("");

    setState(() {
      _futureResult = Future<List<Map<String, String>>>.value(allUserList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _futureResult,
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
                                      currentGroup: dataList[index]["VocelGroup"] ?? "Unassigned",
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
                            child: peopleInkwell(
                                context,
                                widget.userEmail,
                                dataList[index]["email"] ?? "Not set...",
                                dataList[index]["name"] ?? "Not set...",
                                dataList[index]["region"] ?? "Not set...",
                                dataList[index]["aboutMe"] ?? "Not set...",
                                dataList[index]["VocelGroup"] ?? "Unassigned"),
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

Widget peopleInkwell(BuildContext context, String myInfo, String theirEmail, String theirName, String theirRegion, String theirAboutMe, String title) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute
        (builder: (context) =>
      // ChatPage(myInfo: myInfo, theirInfo: theirInfo, title: title),
      FriendProfile(name: theirName, region: theirRegion, email: theirEmail, title: title, aboutMe: theirAboutMe, myInfo: myInfo),
          settings: const RouteSettings(arguments: "")
      ));
      // debuggingPrint("$myInfo is sending message to $theirEmail");
    },
    child: ListTile(
      leading: const CircleAvatar(
        // Specify your avatar properties here
        radius: 18,
        backgroundImage: AssetImage('images/vocel_logo.png'), // Replace with your avatar image
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
          color: title == "leader" ? const Color(constants.primaryDarkTeal) : title == "staff"
              ? const Color(constants.primaryRegularTeal) : title == "parent" ?
                const Color(constants.primaryLightTeal) : Colors.grey[350],
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
  thickness: 0.3,
  indent: 10,
  endIndent: 10,
  color: Color(( constants.primaryDarkTeal.toInt() % 0xFF000000 + 0x66000000)),
);