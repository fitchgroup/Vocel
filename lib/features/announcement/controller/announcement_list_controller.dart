import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/models/Announcement.dart';

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
    Announcement announcement = Announcement(
      tripName: name,
      description: description,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
      isCompleted: false,
      isPinned: false
    );

    final tripsRepository = ref.read(tripsRepositoryProvider);

    await tripsRepository.add(announcement);
  }
}
