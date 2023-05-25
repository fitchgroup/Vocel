import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/services/trips_datastore_service.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  TripsDataStoreService tripsDataStoreService =
  ref.read(tripsDataStoreServiceProvider);
  return TripsRepository(tripsDataStoreService);
});

final tripsListStreamProvider = StreamProvider.autoDispose<List<Announcement?>>((ref) {
  final tripsRepository = ref.watch(tripsRepositoryProvider);
  return tripsRepository.getTrips();
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

class TripsRepository {
  TripsRepository(this.tripsDataStoreService);

  final TripsDataStoreService tripsDataStoreService;

  Stream<List<Announcement>> getTrips() {
    return tripsDataStoreService.listenToAnnouncements();
  }

  Stream<List<Announcement>> getPastTrips() {
    return tripsDataStoreService.listenToPastAnnouncements();
  }

  Future<void> add(Announcement trip) async {
    await tripsDataStoreService.addAnnouncements(trip);
  }

  Future<void> update(Announcement updatedTrip) async {
    await tripsDataStoreService.updateAnnouncements(updatedTrip);
  }

  Future<void> delete(Announcement deletedTrip) async {
    await tripsDataStoreService.deleteAnnouncements(deletedTrip);
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
}
