import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/event_repository.dart';
import 'package:vocel/models/Event.dart';

final eventsListControllerProvider = Provider<EventsListController>((ref) {
  return EventsListController(ref);
});

class EventsListController {
  EventsListController(this.ref);
  final Ref ref;

  Future<void> add({
    required String name,
    required String description,
    required String location,
    required String startDate,
    required String duration,
  }) async {
    Event announcement = Event(
        eventTitle: name,
        eventDescription: description,
        eventLocation: location,
        startTime: TemporalDateTime(DateTime.parse(startDate)),
        duration: int.tryParse(duration) ?? 0,
    );

    final eventsRepository = ref.read(eventsRepositoryProvider);

    await eventsRepository.add(announcement);
  }
}
