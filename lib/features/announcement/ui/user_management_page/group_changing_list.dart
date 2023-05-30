import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_post.dart';
import 'package:vocel/features/announcement/ui/user_management_page/change_group_dialog.dart';

class ManageAccountList extends StatefulWidget {
  const ManageAccountList({super.key});

  @override
  State<ManageAccountList> createState() => _ManageAccountListState();
}

class _ManageAccountListState extends State<ManageAccountList> {
  List<String> desireList = ["leader", "parent", "staff"];
  late Future<List<String>> _futureResultLeader;
  late Future<List<String>> _futureResultParent;
  late Future<List<String>> _futureResultStaff;


  /// get users in a specific group
  Future<List<String>> _getUserInTheList(String element) async {
    List<String> listElement = await getUserInTheList(element);
    return listElement;
  }
  Future<List<String>> getUserInTheList(String desireSingleList) async {
    Map<String, dynamic> listInGroup = await listUsersInGroup(desireSingleList);
    // debuggingPrint("user is ${listInGroup['Users']}");
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
    // _getUserInTheList(desireList[0]).then((listElement) {
    //   print(listElement);
    // });
    _futureResultLeader = _getUserInTheList(desireList[0]);
    _futureResultParent = _getUserInTheList(desireList[1]);
    _futureResultStaff = _getUserInTheList(desireList[2]);
  }

  Future<void> settingGroupStates() async {
    await Future.delayed(const Duration(seconds: 1));
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent, // Back Button Color
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white, // Back Icon Color
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Manage Account",
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Container(
              padding: EdgeInsetsDirectional.zero,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                desireList[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                  letterSpacing: 2,
                  fontFamily: "Ysabeau",
                ),
              ),
            ),
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
                            return ListTile(
                              title: Text(
                                dataList[index],
                                style: const TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  showDialog(
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                  'Edit',
                                ),
                              ),
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
            title: Container(
              padding: EdgeInsetsDirectional.zero,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                desireList[2],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                  letterSpacing: 2,
                  fontFamily: "Ysabeau",
                ),
              ),
            ),
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
                            return ListTile(
                              title: Text(
                                dataList[index],
                                style: const TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  showDialog(
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                  'Edit',
                                ),
                              ),
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
            title: Container(
              padding: EdgeInsetsDirectional.zero,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                desireList[1],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                  letterSpacing: 2,
                  fontFamily: "Ysabeau",
                ),
              ),
            ),
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
                            return ListTile(
                              title: Text(
                                dataList[index],
                                style: const TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  showDialog(
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                  'Edit',
                                ),
                              ),
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
      ),
    );
  }
}


