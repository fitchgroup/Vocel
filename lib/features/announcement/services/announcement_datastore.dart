import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/mutation/announcement_mutation.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/models/CommentAnnouncement.dart';

final tripsDataStoreServiceProvider = Provider<TripsDataStoreService>((ref) {
  final service = TripsDataStoreService();
  return service;
});

class TripsDataStoreService {
  TripsDataStoreService();

  Stream<List<Announcement>> listenToAnnouncements() {
    return Amplify.DataStore.observeQuery(
      Announcement.classType,
      sortBy: [Announcement.TRIPNAME.ascending()],
    )
        .map((event) => event.items
            .where((element) =>

                /// purge announcements after the event pass three months
                element.createdAt == null
                    ? true
                    : element.createdAt!.getDateTimeInUtc().isAfter(DateTime(
                        DateTime.now().year,
                        DateTime.now().month - 3,
                        DateTime.now().day)))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<List<Announcement>> listenToPastAnnouncements() {
    return Amplify.DataStore.observeQuery(
      Announcement.classType,
      sortBy: [Announcement.TRIPNAME.ascending()],
    ).map((event) => event.items.toList()).handleError(
      (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<Announcement> getAnnouncementsStream(String id) {
    final tripStream = Amplify.DataStore.observeQuery(Announcement.classType,
            where: Announcement.ID.eq(id))
        .map((event) => event.items.toList().single);

    return tripStream;
  }

  Future<void> addAnnouncements(Announcement trip) async {
    try {
      await Amplify.DataStore.save(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteAnnouncements(Announcement trip) async {
    try {
      await Amplify.DataStore.delete(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> updateAnnouncements(Announcement updatedTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Announcement.classType,
        where: Announcement.ID.eq(updatedTrip.id),
      );

      final oldTrip = tripsWithId.first;
      final newTrip = oldTrip.copyWith(
        tripName: updatedTrip.tripName,
        description: updatedTrip.description,
        // tripImageKey: updatedTrip.tripImageKey,
        // tripImageUrl: updatedTrip.tripImageUrl,
      );

      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> pinAnnouncements(Announcement pinTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Announcement.classType,
        where: Announcement.ID.eq(pinTrip.id),
      );

      final oldTrip = tripsWithId.first;

      bool assign = oldTrip.isPinned ?? false;
      assign = !assign;

      final newTrip = oldTrip.copyWith(isPinned: assign);

      await updateAnnouncement(newTrip);
      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> completeAnnouncements(Announcement completeTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Announcement.classType,
        where: Announcement.ID.eq(completeTrip.id),
      );

      final oldTrip = tripsWithId.first;

      bool assign = oldTrip.isCompleted ?? false;
      assign = !assign;

      final newTrip = oldTrip.copyWith(isCompleted: assign);

      await Amplify.DataStore.save(newTrip);
      await updateAnnouncement(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// //////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////
  /// ///////////// ADD ANNOUNCEMENT COMMENT ///////////////////////
  /// //////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////

  Future<void> editLikes(
      Announcement likedAnnouncement, String editPerson) async {
    try {
      final announcementsWithId = await Amplify.DataStore.query(
        Announcement.classType,
        where: Announcement.ID.eq(likedAnnouncement.id),
      );

      final oldAnnouncement = announcementsWithId.first;
      List<String> assign = oldAnnouncement.likes != null
          ? List<String>.from(oldAnnouncement.likes!)
          : [];

      if (assign != []) {
        if (assign.contains(editPerson)) {
          assign.remove(editPerson);
        } else {
          assign.add(editPerson);
        }
      } else {
        assign = [editPerson];
      }

      final newAnnouncement = oldAnnouncement.copyWith(likes: assign);

      await Amplify.DataStore.save(newAnnouncement);
      await updateAnnouncement(newAnnouncement);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// TODO: link the Announcement with its Comment
  // Future<List<CommentAnnouncement>> getCommentsForAnnouncement(
  //     Announcement announcement) async {
  //   try {
  //     final comments = await Amplify.DataStore.query(
  //       CommentAnnouncement.classType,
  //       where: (CommentAnnouncement.ANNOUNCEMENT.eq(announcement)),
  //     );
  //     return comments;
  //   } catch (error) {
  //     print('Error retrieving comments: $error');
  //     return [];
  //   }
  // }

  Stream<List<CommentAnnouncement>> listenToComments(
      Announcement thisAnnouncement) {
    return Amplify.DataStore.observeQuery(
      CommentAnnouncement.classType,
      where: CommentAnnouncement.CONTENT.eq(thisAnnouncement.id),
    ).map((event) => event.items.toList()).handleError(
      (error) {
        debugPrint(
            'listenToComments: A Stream error happened in listenToComments');
      },
    );
  }

  Stream<List<CommentAnnouncement>> listenToPastComments() {
    return Amplify.DataStore.observeQuery(
      CommentAnnouncement.classType,
    ).map((event) => event.items.toList()).handleError(
      (error) {
        debugPrint(
            'listenToComments: A Stream error happened in listenToPastComments');
      },
    );
  }

  Stream<CommentAnnouncement> getCommentStream(String id) {
    final commentStream = Amplify.DataStore.observeQuery(
            CommentAnnouncement.classType,
            where: CommentAnnouncement.ID.eq(id))
        .map((event) => event.items.toList().single);

    return commentStream;
  }

  Future<void> addComment(CommentAnnouncement comment) async {
    try {
      await Amplify.DataStore.save(comment);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteComment(CommentAnnouncement comment) async {
    try {
      await Amplify.DataStore.delete(comment);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
