import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/data/trip_repository.dart';
import 'package:vocel/model/Trip.dart';

final tripsListControllerProvider = Provider<TripsListController>((ref) {
  return TripsListController(ref);
});

class TripsListController {
  TripsListController(this.ref);
  final Ref ref;

  Future<void> add({
    required String name,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    Trip trip = Trip(
      tripName: name,
      description: description,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
    );

    final tripsRepository = ref.read(tripsRepositoryProvider);

    await tripsRepository.add(trip);
  }
}
