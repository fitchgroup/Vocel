import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/mutation/announcement_mutation.dart';
import 'package:vocel/features/announcement/mutation/comment_announcement_mutation.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/models/CommentAnnouncement.dart';
import 'package:vocel/models/ProfileRole.dart';

final tripsListControllerProvider = Provider<TripsListController>((ref) {
  return TripsListController(ref);
});

class TripsListController {
  TripsListController(this.ref);

  final Ref ref;

  Future<void> add({
    required String name,
    required String description,
    required ProfileRole profile,
  }) async {
    Announcement announcement = Announcement(
      tripName: name,
      description: description,
      isCompleted: false,
      isPinned: false,
      announcementGroup: profile,
    );

    final tripsRepository = ref.read(tripsRepositoryProvider);

    await tripsRepository.add(announcement);
    await createAnnouncement(announcement);
  }

  Future<void> addComment(
      {required String commentAuthor,
      required String commentContent,
      required Announcement relatedAnnouncement}) async {
    CommentAnnouncement comment = CommentAnnouncement(
      commentAuthor: commentAuthor,
      commentContent: commentContent,
      content: relatedAnnouncement.id,
      announcement: relatedAnnouncement,
    );

    final announcementsRepository = ref.read(tripsRepositoryProvider);

    await announcementsRepository.addComment(comment);
    await createCommentAnnouncement(comment);
  }
}
