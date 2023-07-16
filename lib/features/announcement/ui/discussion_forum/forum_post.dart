import 'package:amplify_core/src/types/temporal/temporal_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/add_comment_bottonsheet.dart';
import 'package:vocel/features/announcement/ui/discussion_forum/forum_comment.dart';
import 'package:vocel/models/ModelProvider.dart';

class ForumPost extends StatefulWidget {
  final callbackLikes;
  final callbackComments;
  final thisPost;
  final currentPerson;

  const ForumPost(
      {Key? key,
      required this.callbackLikes,
      required this.thisPost,
      required this.currentPerson,
      required this.callbackComments})
      : super(key: key);

  @override
  State<ForumPost> createState() => _ForumPostState();
}

class _ForumPostState extends State<ForumPost> {
  AssetImage? profileImage;
  late ValueNotifier<bool> liked;
  late List<String> likeList;
  late List<String> commentList;

  Future<bool> checkProfileImageExists() async {
    try {
      await rootBundle.load('assets/images/profile.png');
      return true;
    } catch (_) {
      return false;
    }
  }

  void showAddCommentDialog(
      BuildContext context, String userEmail, Post thisPost) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddCommentBottomSheet(
            userEmail: userEmail, relatedPost: thisPost);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    liked = ValueNotifier(
      (widget.thisPost as Post).likes != null &&
          (widget.thisPost as Post).likes!.contains(widget.currentPerson),
    );
    checkProfileImageExists().then((exists) {
      if (exists) {
        setState(() {
          profileImage = const AssetImage(
            'assets/images/profile.png',
          );
        });
      } else {
        setState(() {
          profileImage = const AssetImage(
            'images/vocel_logo.png',
          );
        });
      }
    });
    likeList = (widget.thisPost as Post).likes != null
        ? List<String>.from((widget.thisPost as Post).likes!)
        : [];
    commentList = (widget.thisPost as Post).comments != null
        ? List<String>.from((widget.thisPost as Post).comments!)
        : [];
  }

  Future<void> changingLikes() async {
    bool newLiked = !liked.value;
    liked.value = newLiked;
    if (newLiked) {
      likeList.add(widget.currentPerson);
    } else {
      likeList.remove(widget.currentPerson);
    }
  }

  void changingComments() {
    setState(() {
      commentList = (widget.thisPost as Post).comments != null
          ? List<String>.from((widget.thisPost as Post).comments!)
          : [];
    });
  }

  Future<void> handleLike() async {
    // First do the async operation
    await changingLikes();
    await widget.callbackLikes(widget.thisPost, widget.currentPerson);
    // Then update the state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to thread details page
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImage,
                ),
                const SizedBox(width: 8),
                Expanded(
                  // Wrap the row with Expanded
                  flex: 1, // Set flex value greater than 1
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.thisPost.postAuthor ?? "unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          (() {
                            if (widget.thisPost.createdAt != null &&
                                widget.thisPost.createdAt is TemporalDateTime) {
                              final createdDate = (widget.thisPost.createdAt
                                      as TemporalDateTime)
                                  .getDateTimeInUtc()
                                  .toLocal();
                              final now = DateTime.now().toUtc().toLocal();

                              if (createdDate.year == now.year &&
                                  createdDate.month == now.month &&
                                  createdDate.day == now.day) {
                                // Format as hh:mm for today's date
                                return DateFormat('HH: mm').format(createdDate);
                              } else {
                                // Calculate the difference in days
                                final difference =
                                    now.difference(createdDate).inDays;
                                return '${difference.toString()} days ago';
                              }
                            } else if (widget.thisPost.updatedAt != null &&
                                widget.thisPost.updatedAt is TemporalDateTime) {
                              final updatedDate = (widget.thisPost.updatedAt
                                      as TemporalDateTime)
                                  .getDateTimeInUtc()
                                  .toLocal();
                              final now = DateTime.now().toUtc().toLocal();

                              if (updatedDate.year == now.year &&
                                  updatedDate.month == now.month &&
                                  updatedDate.day == now.day) {
                                // Format as hh:mm for today's date
                                return DateFormat('HH: mm').format(updatedDate);
                              } else {
                                // Calculate the difference in days
                                final difference =
                                    now.difference(updatedDate).inDays;
                                return '${difference.toString()} days ago';
                              }
                            } else {
                              return "unknown time";
                            }
                          })(),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.thisPost.postContent,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: handleLike,
                          icon: ValueListenableBuilder<bool>(
                            valueListenable: liked,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return Icon(
                                value
                                    ? Icons.favorite
                                    : Icons.favorite_outline_rounded,
                                color: value ? Colors.red : Colors.grey,
                                size: 25,
                              );
                            },
                          )),
                      const SizedBox(width: 25),
                      IconButton(
                        onPressed: () async {
                          showAddCommentDialog(
                              context, widget.currentPerson, widget.thisPost);
                          changingComments();
                        },
                        icon: const Icon(
                          Icons.messenger_outline_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
            if (likeList.isNotEmpty)
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Liked by ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        if (likeList.length <= 3)
                          TextSpan(
                            text: likeList.join(", "),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          TextSpan(
                            text: likeList.sublist(0, 3).join(", "),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          const TextSpan(
                            text: ' and',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          TextSpan(
                            text: ' ${likeList.length - 3} others',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            CommentList(
              postId: widget.thisPost,
            )
          ],
        ),
      ),
    );
  }
}
