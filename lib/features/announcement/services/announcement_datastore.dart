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

  Stream<List<Announcement>> listenToTrips() {
    return Amplify.DataStore.observeQuery(
      Announcement.classType,
      sortBy: [Announcement.ENDDATE.ascending()],
    )
        .map((event) => event.items
        .where((element) =>
        element.startDate.getDateTime().isAfter(DateTime.now()))
        .toList())
        .handleError(
          (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<List<Announcement>> listenToPastTrips() {
    return Amplify.DataStore.observeQuery(
      Announcement.classType,
      sortBy: [Announcement.STARTDATE.ascending()],
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

  Stream<Announcement> getTripStream(String id) {
    final tripStream =
    Amplify.DataStore.observeQuery(Announcement.classType, where: Announcement.ID.eq(id))
        .map((event) => event.items.toList().single);

    return tripStream;
  }

  Future<void> addTrip(Announcement trip) async {
    try {
      await Amplify.DataStore.save(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteTrip(Announcement trip) async {
    try {
      await Amplify.DataStore.delete(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> updateTrip(Announcement updatedTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Announcement.classType,
        where: Announcement.ID.eq(updatedTrip.id),
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
}
