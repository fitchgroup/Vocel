import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_post.dart';

class ManageAccountList extends StatefulWidget {
  const ManageAccountList({super.key});

  @override
  State<ManageAccountList> createState() => _ManageAccountListState();
}

class _ManageAccountListState extends State<ManageAccountList> {
  List<String> desireList = ["leader", "parent", "staff"];

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
  }

  void _showChangeGroupDialog(BuildContext context, String currentGroup, String currentUserEmail) {
    String selectedGroup = currentGroup;
    String? shouldChange = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Groups'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('Leader'),
                value: 'leader',
                groupValue: selectedGroup,
                onChanged: (value) {
                  shouldChange = value;
                },
              ),
              RadioListTile<String>(
                title: const Text('Staff'),
                value: 'staff',
                groupValue: selectedGroup,
                onChanged: (value) {
                  shouldChange = value;
                },
              ),
              RadioListTile<String>(
                title: const Text('Parent'),
                value: 'parent',
                groupValue: selectedGroup,
                onChanged: (value) {
                  shouldChange = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                debuggingPrint(currentGroup);
                debuggingPrint(currentUserEmail);
                debuggingPrint(shouldChange!);
                if(shouldChange != null)
                {
                  changeUsersGroups(selectedGroup, shouldChange!, currentUserEmail);
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
            title: Text(
              desireList[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
                letterSpacing: 2,
                fontFamily: "Ysabeau"
              ),
            ),
            children: [
              SizedBox(
                height: 200, // Replace 200 with your desired height
                child: FutureBuilder<List<String>>(
                  future: _getUserInTheList(desireList[0]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
                                    letterSpacing: 0.5
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _showChangeGroupDialog(context, desireList[0], dataList[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    'Edit'
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
            title: Text(
              desireList[2],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
                  letterSpacing: 2,
                  fontFamily: "Ysabeau"
              ),
            ),
            children: [
              SizedBox(
                height: 200,
                child: FutureBuilder<List<String>>(
                  future: _getUserInTheList(desireList[2]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
                                    letterSpacing: 0.5
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _showChangeGroupDialog(context, desireList[2], dataList[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    'Edit'
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
            title: Text(
              desireList[1],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
                  letterSpacing: 2,
                  fontFamily: 'Ysabeau',
              ),
            ),
            children: [
              SizedBox(
                height: 200,
                child: FutureBuilder<List<String>>(
                  future: _getUserInTheList(desireList[1]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
                                  letterSpacing: 0.5
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _showChangeGroupDialog(context, desireList[1], dataList[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(constants.primaryRegularTeal), // Change background color to red
                                ),
                                child: const Text(
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    'Edit'
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


