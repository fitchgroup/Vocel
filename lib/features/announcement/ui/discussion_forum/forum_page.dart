import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/discussion_forum/forum_post.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Discussion Forum",
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
        onPressed: () {
          // navigate to create new thread page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

