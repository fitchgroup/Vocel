import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


Future<List> fetchGroups() async {
  List groups = List.filled(0, 0);
  try {
    final result = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String accessToken = ((result as CognitoAuthSession).userPoolTokens)!
        .accessToken; //.idToken;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    groups = decodedToken["cognito:groups"];
  } on AuthException catch (e) {
    debuggingPrint("$e \n ${"*"*20} fetchGroups Fail ${"="*20}");
  }
  return groups;
}

Future<Map<String, String>> getUserAttributes() async {
  // Fetch the user's attributes
  List<AuthUserAttribute> userAttributes = await Amplify.Auth.fetchUserAttributes();

  Map<String, String> stringMap = {};

  for (int i = 0; i < userAttributes.length; i += 1) {
    String key = userAttributes[i].userAttributeKey.toString();
    String value = userAttributes[i].value;

    stringMap[key.toString()] = value.toString();
  }

  return stringMap;

  // Find and modify the group attribute
  // List<AuthUserAttribute> modifiedAttributes = [];
  // UserAttributeKey store = userAttributes.first.userAttributeKey;?
  // for (AuthUserAttribute attribute in userAttributes) {
  //   print("**"*40 + attribute.userAttributeKey.toString());
  //   print("**"*40 + attribute.value);
  //   if (attribute.userAttributeKey == "cognito:groups") {
  //     store = attribute.userAttributeKey;
  //     modifiedAttributes.add(AuthUserAttribute(
  //       userAttributeKey: attribute.userAttributeKey,
  //       value: desireGroup, // Change the group to desireGroup
  //     ));
  //   } else if (attribute.userAttributeKey != 'sub') {
  //     modifiedAttributes.add(attribute);
  //   }
  // }

  // Update the user's attributes
  // await Amplify.Auth.updateUserAttribute(
  //   userAttributeKey: store, // Replace 'group' with your custom attribute name
  //   value: desireGroup,
  // );

}

Future<void> addUserGroup(String desireGroup, {String? email}) async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  if(email != null){
    userName = email;
  }
  try {
    // const apiName = 'AdminQueries';
    const path = '/addUserToGroup';
    final body = {
      "username" : userName,
      "groupname": desireGroup
    };
    final bodyBytes = utf8.encode(jsonEncode(body));
    final authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    final accessToken =
        (authSession as CognitoAuthSession).userPoolTokens!.accessToken;


    // body here is a Unit8List. Uint8List is a typed list of unsigned 8-bit integers (bytes) in Dart and Flutter. It is commonly used to represent binary data or byte arrays.
    // RestOptions restOptions = RestOptions(path: '/addUserToGroup', body: bodyUint8List, headers: headers);
    // Amplify.API.post(restOptions: restOptions);

    final myInit = RestOptions(
      body: Uint8List.fromList(bodyBytes), // Convert bodyBytes to Uint8List
      path: path,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    // Make API call using myInit options
    Amplify.API.post(restOptions: myInit);

  } catch (e) {
      print("$e \n ${"*"*20} addUserGroup Fail ${"="*20}");
  }
}

Future<void> removeUserGroup(String originalGroup, {String? email}) async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  if(email != null) {
    userName = email;
  }
  try {
    const pathRemove = '/removeUserFromGroup';
    final bodyRemove = {
      "username" : userName,
      "groupname": originalGroup
    };
    final bodyBytesRemove = utf8.encode(jsonEncode(bodyRemove));
    final authSessionRemove = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    final accessToken =
        (authSessionRemove as CognitoAuthSession).userPoolTokens!.accessToken;
    final myInit = RestOptions(
      body: Uint8List.fromList(bodyBytesRemove), // Convert bodyBytes to Uint8List
      path: pathRemove,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    /// sent post request
    Amplify.API.post(restOptions: myInit);
  } catch (e) {
    // Attribute update failed
    debuggingPrint("$e \n ${"*"*20} removeUserGroup Fail ${"="*20}");
  }
}

Future<void> changeUsersGroups(String originalGroup, String desireGroup, String userEmail) async {
  removeUserGroup(originalGroup, email: userEmail);
  addUserGroup(desireGroup, email: userEmail);
}


Future<Map<String, dynamic>> listGroupsForUser() async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  String nextToken = "";
  Map<String, dynamic> jsonMap = {};
  try {
    const pathRemove = '/listGroupsForUser';
    final Map<String, String> bodyRemove = {
      "username": userName!,
      "token": nextToken,
    };
    final authSessionRemove = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    final accessToken =
        (authSessionRemove as CognitoAuthSession).userPoolTokens!.accessToken;
    final myInit = RestOptions(
      queryParameters: bodyRemove, // Convert bodyBytes to Uint8List
      path: pathRemove,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    /// sent get request
    RestResponse responseData = await Amplify.API.get(restOptions: myInit).response;
    jsonMap = jsonDecode(responseData.body);
    // String nextToken = responseData['NextToken'] as String;
    return jsonMap;
  } catch (e) {
    // Attribute update failed
    debuggingPrint("$e \n ${"*"*20} listGroupsForUser Fail ${"="*20}");
  }
  return jsonMap;
}


Future<dynamic> listUsersInGroup(String groupName) async {
  // Map<String, String> stringMap = await getUserAttributes();
  // String? userName = stringMap['email'];
  String nextToken = "";
  try {
    const pathListUser = '/listUsersInGroup';
    final Map<String, String> bodyListUser = {
      "groupname": groupName,
      "token": nextToken,
    };
    final authSessionListUser = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    final accessToken =
        (authSessionListUser as CognitoAuthSession).userPoolTokens!.accessToken;
    final myInit = RestOptions(
      queryParameters: bodyListUser, // Convert bodyBytes to Uint8List
      path: pathListUser,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    /// sent get request
    RestResponse responseData = await Amplify.API.get(restOptions: myInit).response;
    Map<String, dynamic> jsonMap = jsonDecode(responseData.body);
    // String nextToken = responseData['NextToken'] as String;
    return jsonMap;
  } catch (e) {
      debuggingPrint("$e ${"*"*20} listUsersInGroup Fail ${"="*20}");
  }
  return null;
}


Future<bool> checkValidFuture(String currentGroup) async {
  if(currentGroup == 'admin' || currentGroup == 'leader' || currentGroup == 'staff') {
    return true;
  }
  return false;
}


bool checkValid(String currentGroup) {
  List<String> stringList = ['staff', 'parent', 'admin', 'default', 'leader'];
  if(stringList.contains(currentGroup)) {
    return true;
  }
  return false;
}

void debuggingPrint(String shouldPrint) {
  if (kDebugMode) {
    print("--"*100);
    print(shouldPrint);
    print("--"*100);
  }
}

