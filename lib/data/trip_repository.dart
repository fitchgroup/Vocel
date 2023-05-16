import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/Trip.dart';
import 'package:vocel/services/trips_datastore_service.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  TripsDataStoreService tripsDataStoreService =
  ref.read(tripsDataStoreServiceProvider);
  return TripsRepository(tripsDataStoreService);
});

final tripsListStreamProvider = StreamProvider.autoDispose<List<Trip?>>((ref) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getTrips();
});

final pastTripsListStreamProvider =
StreamProvider.autoDispose<List<Trip?>>((ref) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getPastTrips();
});

final tripProvider =
StreamProvider.autoDispose.family<Trip?, String>((ref, id) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.get(id);
});

class TripsRepository {
  TripsRepository(this.tripsDataStoreService);

  final TripsDataStoreService tripsDataStoreService;

  Stream<List<Trip>> getTrips() {
    return tripsDataStoreService.listenToAnnouncements();
  }

  Stream<List<Trip>> getPastTrips() {
    return tripsDataStoreService.listenToPastAnnouncements();
  }

  Future<void> add(Trip trip) async {
    await tripsDataStoreService.addAnnouncements(trip);
  }

  Future<void> update(Trip updatedTrip) async {
    await tripsDataStoreService.updateAnnouncements(updatedTrip);
  }

  Future<void> delete(Trip deletedTrip) async {
    await tripsDataStoreService.deleteAnnouncements(deletedTrip);
  }

  Future<void> pinMe(Trip pinTrip) async {
    await tripsDataStoreService.pinAnnouncements(pinTrip);
  }

  Future<void> completeMe(Trip completeTrip) async {
    await tripsDataStoreService.completeAnnouncements(completeTrip);
  }

  Stream<Trip> get(String id) {
    return tripsDataStoreService.getAnnouncementsStream(id);
  }
}
