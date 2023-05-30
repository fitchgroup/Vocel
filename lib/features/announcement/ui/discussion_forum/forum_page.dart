import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_post.dart';

class ForumPage extends HookConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: 'addPost',
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
        title: Text(
          const LocalizedButtonResolver().discussionForum(context),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: ListView.builder(
        itemCount: 10, // number of discussion threads
        itemBuilder: (BuildContext context, int index) {
          return ForumPost(index: index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(constants.primaryColorDark),
        onPressed: () {
          // showAddAnnouncementDialog(context);
          debuggingPrint("adding post");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
