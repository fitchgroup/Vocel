import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/Trip.dart';

final tripsDataStoreServiceProvider = Provider<TripsDataStoreService>((ref) {
  final service = TripsDataStoreService();
  return service;
});

class TripsDataStoreService {
  TripsDataStoreService();

  Stream<List<Trip>> listenToAnnouncements() {
    return Amplify.DataStore.observeQuery(
      Trip.classType,
      sortBy: [Trip.STARTDATE.ascending()],
    )
        .map((event) => event.items
        .where((element) =>
        element.endDate.getDateTime().isAfter(DateTime.now()))
        .toList())
        .handleError(
          (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<List<Trip>> listenToPastAnnouncements() {
    return Amplify.DataStore.observeQuery(
      Trip.classType,
      sortBy: [Trip.STARTDATE.ascending()],
    )
        .map((event) => event.items
        .where((element) =>
        element.endDate.getDateTime().isBefore(DateTime.now()))
        .toList())
        .handleError(
          (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<Trip> getAnnouncementsStream(String id) {
    final tripStream =
    Amplify.DataStore.observeQuery(Trip.classType, where: Trip.ID.eq(id))
        .map((event) => event.items.toList().single);

    return tripStream;
  }

  Future<void> addAnnouncements(Trip trip) async {
    try {
      await Amplify.DataStore.save(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteAnnouncements(Trip trip) async {
    try {
      await Amplify.DataStore.delete(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> updateAnnouncements(Trip updatedTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Trip.classType,
        where: Trip.ID.eq(updatedTrip.id),
      );

      final oldTrip = tripsWithId.first;
      final newTrip = oldTrip.copyWith(
        tripName: updatedTrip.tripName,
        description: updatedTrip.description,
        startDate: updatedTrip.startDate,
        endDate: updatedTrip.endDate,
        // tripImageKey: updatedTrip.tripImageKey,
        // tripImageUrl: updatedTrip.tripImageUrl,
      );

      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> pinAnnouncements(Trip pinTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Trip.classType,
        where: Trip.ID.eq(pinTrip.id),
      );

      final oldTrip = tripsWithId.first;

      bool assign = oldTrip.isPin ?? false;
      assign = !assign;

      final newTrip = oldTrip.copyWith(
          isPin: assign
      );

      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> completeAnnouncements(Trip completeTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Trip.classType,
        where: Trip.ID.eq(completeTrip.id),
      );

      final oldTrip = tripsWithId.first;

      bool assign = oldTrip.isCompleted ?? false;
      assign = !assign;

      final newTrip = oldTrip.copyWith(
          isCompleted: assign
      );

      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
