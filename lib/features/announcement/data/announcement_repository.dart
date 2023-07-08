import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/mutation/announcement_mutation.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/features/announcement/services/announcement_datastore.dart';
import 'package:vocel/models/CommentAnnouncement.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  TripsDataStoreService tripsDataStoreService =
  ref.read(tripsDataStoreServiceProvider);
  return TripsRepository(tripsDataStoreService);
});

final tripsListStreamProvider =
StreamProvider.autoDispose<List<Announcement?>>((ref) async* {
  final tripsRepository = ref.watch(tripsRepositoryProvider);

  List<Announcement?> serverAnnouncement = await queryAnnouncementListItems();
  if (serverAnnouncement.isNotEmpty) {
    for (var announcement in serverAnnouncement) {
      await Amplify.DataStore.save(announcement!);
    }
  }

  yield* tripsRepository.getTrips();
});

final pastTripsListStreamProvider =
StreamProvider.autoDispose<List<Announcement?>>((ref) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getPastTrips();
});

final tripProvider =
StreamProvider.autoDispose.family<Announcement?, String>((ref, id) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.get(id);
});

final commentsListStreamProvider = StreamProvider.autoDispose
    .family<List<CommentAnnouncement?>, Announcement>((ref, announcement) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getComments(announcement);
});

final pastCommentsListStreamProvider =
StreamProvider.autoDispose<List<CommentAnnouncement?>>((ref) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getPastComments();
});

final commentProvider =
StreamProvider.autoDispose.family<CommentAnnouncement?, String>((ref, id) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.get2(id);
});

class TripsRepository {
  TripsRepository(this.tripsDataStoreService);

  final TripsDataStoreService tripsDataStoreService;

  Stream<List<Announcement>> getTrips() {
    return tripsDataStoreService.listenToAnnouncements();
  }

  Stream<List<Announcement>> getPastTrips() {
    return tripsDataStoreService.listenToPastAnnouncements();
  }

  Stream<List<CommentAnnouncement>> getComments(Announcement thisAnnouncement) {
    return tripsDataStoreService.listenToComments(thisAnnouncement);
  }

  Stream<List<CommentAnnouncement>> getPastComments() {
    return tripsDataStoreService.listenToPastComments();
  }

  Future<void> add(Announcement trip) async {
    await tripsDataStoreService.addAnnouncements(trip);
  }

  Future<void> addComment(CommentAnnouncement event) async {
    await tripsDataStoreService.addComment(event);
  }

  Future<void> update(Announcement updatedTrip) async {
    await tripsDataStoreService.updateAnnouncements(updatedTrip);
  }

  Future<void> delete(Announcement deletedTrip) async {
    await tripsDataStoreService.deleteAnnouncements(deletedTrip);
  }

  Future<void> deleteComment(CommentAnnouncement deletedComment) async {
    await tripsDataStoreService.deleteComment(deletedComment);
  }

  Future<void> likeAnnouncement(Announcement likedPost,
      String editPerson) async {
    await tripsDataStoreService.editLikes(likedPost, editPerson);
  }

  Future<void> pinMe(Announcement pinTrip) async {
    await tripsDataStoreService.pinAnnouncements(pinTrip);
  }

  Future<void> completeMe(Announcement completeTrip) async {
    await tripsDataStoreService.completeAnnouncements(completeTrip);
  }

  Stream<Announcement> get(String id) {
    return tripsDataStoreService.getAnnouncementsStream(id);
  }

  Stream<CommentAnnouncement> get2(String id) {
    return tripsDataStoreService.getCommentStream(id);
  }
}
