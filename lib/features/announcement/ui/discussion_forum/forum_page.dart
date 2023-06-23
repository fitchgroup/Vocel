import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/post_controller.dart';
import 'package:vocel/features/announcement/data/post_repository.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/add_post_bottomsheet.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_post.dart';
import 'package:vocel/features/announcement/ui/home_page/home_navigation_bar.dart';
import 'package:vocel/models/Post.dart';

class ForumPage extends HookConsumerWidget {
  final bool showEdit;
  final String userEmail;
  final String myName;
  final ValueChanged<String> onClickController;
  final groupOfUser;

  const ForumPage(
      {Key? key,
      required this.showEdit,
      required this.userEmail,
      required this.myName,
      required this.onClickController,
      required this.groupOfUser})
      : super(key: key);

  void showAddEventDialog(BuildContext context, String userEmail) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddPostBottomSheet(
          userEmail: userEmail,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Post?>> postValue =
        ref.watch(postsListStreamProvider);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: [
          'Staffversion1',
          'Bellversion1',
          'Eetcversion1',
          'Vcpaversion1'
        ].contains(groupOfUser), // visibilityButton.value,
        child: FloatingActionButton(
          heroTag: "PostFloatingActionButton",
          backgroundColor: const Color(constants.primaryDarkTeal),
          onPressed: () async {
            showAddEventDialog(context, userEmail);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Set a fixed height
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopNavigationHomeBar(
                onClickController: onClickController,
                current: "Post",
              ),
              postValue.when(
                  data: (event) => event.isEmpty
                      ? const Center(
                          child: Text("No Post"),
                        )
                      : buildPosts(
                          event.whereType<Post>().toList(), context, ref),
                  error: (e, st) => const Center(
                        child: Text('Error Here'),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  Center buildPosts(List<Post> posts, BuildContext context, WidgetRef ref) {
    posts.sort((a, b) {
      DateTime? comparedTimeFromA;
      DateTime? comparedTimeFromB;
      if (a.updatedAt != null) {
        comparedTimeFromA = a.updatedAt!.getDateTimeInUtc();
      } else if (a.createdAt != null) {
        comparedTimeFromA = a.createdAt!.getDateTimeInUtc();
      }

      if (b.updatedAt != null) {
        comparedTimeFromB = b.updatedAt!.getDateTimeInUtc();
      } else if (b.createdAt != null) {
        comparedTimeFromB = b.createdAt!.getDateTimeInUtc();
      }

      if (comparedTimeFromA == null && comparedTimeFromB != null) {
        return -1; // a should come before b
      } else if (comparedTimeFromB == null && comparedTimeFromA != null) {
        return 1; // b should come before a
      } else if (comparedTimeFromA != null && comparedTimeFromB != null) {
        return -1 * comparedTimeFromA.compareTo(comparedTimeFromB);
      } else {
        return a.postAuthor.compareTo(b.postAuthor);
      }
    });

    void likePost(Post likedPost, String editPerson) {
      ref.read(postControllerProvider).editLikes(likedPost, editPerson);
      Navigator.of(context).pop(false); // Dismiss the dialog and delete
    }

    return Center(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Dismissible(
              key: Key(post.id),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Show confirmation dialog for delete action
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Event"),
                        content: const Text(
                            "Are you sure you want to delete this event?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(
                                  false); // Dismiss the dialog and don't delete
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () {
                              ref.read(postControllerProvider).delete(post);
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog and delete
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              background: Container(
                color: Colors.blueGrey[600]?.withOpacity(0.4),
                // Customize the background color for complete action
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red[800]?.withOpacity(0.6),
                // Customize the background color for delete action
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              // Only allow end to start swipe
              child: ForumPost(thisPost: post, callbackLikes: likePost),
            );
          }),
    );
  }
}
