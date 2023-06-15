import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

extension AWSApiPluginConfigHelpers on AWSApiPluginConfig {
  List<String> getAllApiNames() {
    final apiNames = <String>[];
    final configs = entries.map((entry) => entry.value);

    for (final config in configs) {
      final name = config.apiKey;
      if (name != null) {
        apiNames.add(name);
      }
    }

    manageUserDebuggingPrint(apiNames.toString());
    return apiNames;
  }
}

/// TODO: change version from V0 to V1

// v1
Future<List> fetchGroups() async {
  // v1
  List groups = List.filled(0, 0);
  final session = await Amplify.Auth.getPlugin(
    AmplifyAuthCognito.pluginKey,
  ).fetchAuthSession();

// AuthResult.value will throw if the underlying operation failed.
  try {
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();
    // debuggingPrint("accessToken in fetchGroups is: $accessToken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    groups = decodedToken["cognito:groups"];
    // `AuthResult.valueOrNull` will return the identityId if present or null,
    // but will never throw even if the underlying operation failed.
    final identityId = session.identityIdResult.valueOrNull;
    //safePrint('identityId: $identityId');
  } on SignedOutException {
    // the user is not signed in.
  } on SessionExpiredException {
    // the users session has expired.
  } on NetworkException {
    // the access and/or id token is expired but cannot be refreshed because the
    // user is offline.
  }
  return groups;
}

Future<Map<String, String>> getUserAttributes() async {
  // Fetch the user's attributes
  List<AuthUserAttribute> userAttributes =
      await Amplify.Auth.fetchUserAttributes();

  Map<String, String> stringMap = {};

  for (int i = 0; i < userAttributes.length; i += 1) {
    String key = userAttributes[i].userAttributeKey.key;
    String value = userAttributes[i].value;

    stringMap[key.toString()] = value.toString();
  }

  return stringMap;
}

Future<void> addVocelUserAttribute(
    {required String attrName, required String attrValue}) async {
  try {
    final myKey = CognitoUserAttributeKey.custom(attrName);
    final attribute =
        AuthUserAttribute(value: attrValue, userAttributeKey: myKey);
    await Amplify.Auth.updateUserAttributes(attributes: [attribute]);
    await Amplify.Auth.updateUserAttribute(
        userAttributeKey: myKey, value: attrValue);
  } catch (e) {
    manageUserDebuggingPrint('Error adding user attribute: $e');
  }
}

Future<void> addUserGroup(String desireGroup, {String? email}) async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  if (email != null) {
    userName = email;
  }
  try {
    // const apiName = 'AdminQueries';
    const path = '/addUserToGroup';
    final body = {"username": userName, "groupname": desireGroup};

    // v1
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();

    // body here is a Unit8List. Uint8List is a typed list of unsigned 8-bit integers (bytes) in Dart and Flutter. It is commonly used to represent binary data or byte arrays.
    // RestOptions restOptions = RestOptions(path: '/addUserToGroup', body: bodyUint8List, headers: headers);
    // Amplify.API.post(restOptions: restOptions);
    final myInit = <String, dynamic>{
      'body': HttpPayload.json(body),
      'path': path,
      'headers': {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    };

    // Make API call using myInit options
    Amplify.API.post(
      myInit["path"],
      headers: myInit["headers"],
      body: myInit["body"],
    );
  } catch (e) {
    manageUserDebuggingPrint("$e \n ${"*" * 20} addUserGroup Fail ${"=" * 20}");
  }
}

Future<void> removeUserGroup(String originalGroup, {String? email}) async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  if (email != null) {
    userName = email;
  }
  try {
    const pathRemove = '/removeUserFromGroup';
    final bodyRemove = {"username": userName, "groupname": originalGroup};
    final bodyBytesRemove = utf8.encode(jsonEncode(bodyRemove));

    // v1
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();

    final myInit = <String, dynamic>{
      "body": HttpPayload.json(bodyRemove),
      // Convert bodyBytes to Uint8List
      "path": pathRemove,
      "headers": {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    };

    /// sent post request
    Amplify.API.post(
      myInit["path"],
      headers: myInit["headers"],
      body: myInit["body"],
    );
  } catch (e) {
    // Attribute update failed
    manageUserDebuggingPrint(
        "$e \n ${"*" * 20} removeUserGroup Fail ${"=" * 20}");
  }
}

Future<void> changeUsersGroups(
    String originalGroup, String desireGroup, String userEmail) async {
  removeUserGroup(originalGroup, email: userEmail);
  addUserGroup(desireGroup, email: userEmail);
}

Future<Map<String, dynamic>> listGroupsForUser(
    {String? receivedUserName}) async {
  Map<String, String> stringMap = await getUserAttributes();
  String? userName = stringMap['email'];
  if (receivedUserName != null) {
    userName = receivedUserName;
  }
  String nextToken = "";
  Map<String, dynamic> jsonMap = {};
  try {
    const pathRemove = '/listGroupsForUser';
    final Map<String, String> bodyList = {
      "username": userName!,
      "token": nextToken,
    };
    // v1
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();

    final myInit = <String, dynamic>{
      "queryParameters": bodyList, // Convert bodyBytes to Uint8List
      "path": pathRemove,
      "headers": {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    };

    /// sent get request
    var responseData = await Amplify.API
        .get(
          myInit["path"],
          headers: myInit["headers"],
          queryParameters: myInit["queryParameters"],
        )
        .response;

    jsonMap = jsonDecode(responseData.decodeBody());
    return jsonMap;
  } catch (e) {
    // Attribute update failed
    manageUserDebuggingPrint(
        "$e \n ${"*" * 20} listGroupsForUser Fail ${"=" * 20}");
  }
  return jsonMap;
}

Future<dynamic> listUsersInGroup(String groupName) async {
  String nextToken = "";
  try {
    const pathListUser = '/listUsersInGroup';
    final Map<String, String> bodyListUser = {
      "groupname": groupName,
      "token": nextToken,
    };
    // v1
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();

    final myInit = <String, dynamic>{
      "queryParameters": bodyListUser, // Convert bodyBytes to Uint8List
      "path": pathListUser,
      "headers": {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    };

    /// sent get request
    var responseData = await Amplify.API
        .get(
          myInit["path"],
          headers: myInit["headers"],
          queryParameters: myInit["queryParameters"],
        )
        .response;
    Map<String, dynamic> jsonMap = jsonDecode(responseData.decodeBody());
    // String nextToken = responseData['NextToken'] as String;
    return jsonMap;
  } catch (e) {
    manageUserDebuggingPrint(
        "$e ${"*" * 20} listUsersInGroup Fail ${"=" * 20}");
  }
  return null;
}

Future<dynamic> listAllUsersInGroup() async {
  String nextToken = "";
  try {
    const pathListUser = '/listUsers';
    final Map<String, String> bodyListUser = {
      "token": nextToken,
    };
    // v1
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    final accessToken = session.userPoolTokensResult.value.accessToken.toJson();
    final myInit = <String, dynamic>{
      "queryParameters": bodyListUser, // Convert bodyBytes to Uint8List
      "path": pathListUser,
      "headers": {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    };

    /// sent get request
    var responseData = await Amplify.API
        .get(
          myInit["path"],
          headers: myInit["headers"],
          queryParameters: myInit["queryParameters"],
        )
        .response;
    Map<String, dynamic> jsonMap = jsonDecode(responseData.decodeBody());
    // String nextToken = responseData['NextToken'] as String;
    return jsonMap;
  } catch (e) {
    manageUserDebuggingPrint("$e ${"*" * 20} listUsers Fail ${"=" * 20}");
  }
  return null;
}

void manageUserDebuggingPrint(String shouldPrint) {
  if (kDebugMode) {
    print("--" * 100);
    print(shouldPrint);
    print("--" * 100);
  }
}

Future<bool> verifyAdminAccess() async {
  Map<String, dynamic> jsonMap = await listGroupsForUser();
  List<String> validGroups = ['Staffversion1'];
  for (var entry in jsonMap.entries) {
    manageUserDebuggingPrint("${entry.key} + ${entry.value}");
  }
  bool hasValidGroup = false;
  if (jsonMap.isNotEmpty) {
    hasValidGroup = jsonMap["Groups"].any((element) {
      return validGroups.contains(element['GroupName'].toString());
    });
  }
  return hasValidGroup;
}

Future<String> verifyGroupAccess() async {
  Map<String, dynamic> jsonMap = await listGroupsForUser();
  // any new users into each of the three other profile roles (BELL, EETC, VCPA )
  List<String> validGroups = ['Bellversion1', 'Eetcversion1', 'Vcpaversion1'];
  for (var entry in jsonMap.entries) {
    manageUserDebuggingPrint("${entry.key} + ${entry.value}");
  }
  String groupName;
  jsonMap["Groups"].forEach((element) {
    String currentGroupName = element['GroupName'].toString();
    if (validGroups.contains(currentGroupName)) {
      groupName = currentGroupName;
      return groupName;
    }
  });
  return "";
}
