import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/Announcement.dart';

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
    ).map((event) => event.items.toList()).handleError(
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
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
