import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:amplify_core/src/types/temporal/temporal_datetime.dart';
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/mutation/comment_announcement_mutation.dart';
import 'package:vocel/models/ModelProvider.dart';

class AnnouncementCommentList extends HookConsumerWidget {
  final Announcement announcementId;

  const AnnouncementCommentList({required this.announcementId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CommentAnnouncement?>> commentValue =
        ref.watch(commentsListStreamProvider(announcementId));

    return commentValue.when(
      data: (comments) {
        if (comments.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.grey[500],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(9)),
                            child: GestureDetector(
                              onLongPress: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Comment"),
                                      content: const Text(
                                          "Are you sure you want to delete this comment?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Delete"),
                                          onPressed: () {
                                            ref
                                                .read(tripControllerProvider)
                                                .deleteComment(comment);
                                            deleteCommentAnnouncement(comment);
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                color: Colors.grey.shade100,
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          comment!.commentAuthor,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          (() {
                                            if (comment.createdAt != null &&
                                                comment.createdAt
                                                    is TemporalDateTime) {
                                              final createdDate =
                                                  (comment.createdAt
                                                          as TemporalDateTime)
                                                      .getDateTimeInUtc()
                                                      .toLocal();
                                              final now = DateTime.now()
                                                  .toUtc()
                                                  .toLocal();

                                              if (createdDate.year ==
                                                      now.year &&
                                                  createdDate.month ==
                                                      now.month &&
                                                  createdDate.day == now.day) {
                                                // Format as hh:mm for today's date
                                                return DateFormat('HH:mm')
                                                    .format(createdDate);
                                              } else {
                                                final difference = now
                                                    .difference(createdDate)
                                                    .inDays;
                                                return '${difference.toString()} days ago';
                                              }
                                            } else {
                                              return "unknown time";
                                            }
                                          })(),
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      comment.commentContent,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Divider(
                                      color: Colors.grey.shade700,
                                      thickness: 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 0);
        }
      },
      loading: () => const SizedBox(height: 0),
      error: (error, stackTrace) => Text('Error loading comments: $error'),
    );
  }
}
