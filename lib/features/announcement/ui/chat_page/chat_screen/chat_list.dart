import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/announcements_list/navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_list_page.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_box.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/chat_search.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  void onClickController(String change) {

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatSearchBar(onClickController: onClickController),
        const Center(
          heightFactor: 3,
          // child: SpinKitCircle(
          //   size: 60,
          //   color: Color(constants.primaryColorDark),
          // )
        )
      ],
    );
  }
}
