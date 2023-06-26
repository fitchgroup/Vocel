import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/services/event_datastore.dart';
import 'package:vocel/models/VocelEvent.dart';

/// eventsRepositoryProvider: This provider defines the EventsRepository instance
/// by taking an EventsDataStoreService instance as a dependency. It is responsible
/// for providing the repository for events, which will be used by other parts of the
/// application.

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  EventsDataStoreService eventsDataStoreService =
  ref.read(eventsDataStoreServiceProvider);
  return EventsRepository(eventsDataStoreService);
});

/// eventsListStreamProvider: This provider creates a stream of a list of events (List<Event?>).
/// It depends on the eventsRepositoryProvider and retrieves the events using the getEvents()
/// method from the EventsRepository.

final eventsListStreamProvider = StreamProvider.autoDispose<List<VocelEvent?>>((ref) {
  final eventsRepository = ref.watch(eventsRepositoryProvider);
  return eventsRepository.getEvents();
});

/// pastEventsListStreamProvider: This provider creates a stream of a list of past events (List<Event?>).
/// It depends on the eventsRepositoryProvider and retrieves the past events using the getPastEvents()
/// method from the EventsRepository.

final pastEventsListStreamProvider =
StreamProvider.autoDispose<List<VocelEvent?>>((ref) {
  final eventsRepository = ref.watch(eventsRepositoryProvider);
  return eventsRepository.getPastEvents();
});

/// eventProvider: This provider creates a stream of a single event (Event?) based on the provided id.
/// It depends on the eventsRepositoryProvider and retrieves the specific event using the get(id) method
/// from the EventsRepository.

final eventProvider =
StreamProvider.autoDispose.family<VocelEvent?, String>((ref, id) {
  final eventsRepository = ref.watch(eventsRepositoryProvider);
  return eventsRepository.get(id);
});

/// EventsRepository: This class is responsible for interacting with the EventsDataStoreService and providing
/// methods to get, add, update, and delete events. It takes an EventsDataStoreService instance as a dependency
/// and delegates the corresponding operations to it.

class EventsRepository {
  EventsRepository(this.eventsDataStoreService);

  final EventsDataStoreService eventsDataStoreService;

  Stream<List<VocelEvent>> getEvents() {
    return eventsDataStoreService.listenToEvents();
  }

  Stream<List<VocelEvent>> getPastEvents() {
    return eventsDataStoreService.listenToPastEvents();
  }

  Future<void> add(VocelEvent event) async {
    await eventsDataStoreService.addEvent(event);
  }

  Future<void> update(VocelEvent updatedEvent) async {
    await eventsDataStoreService.updateEvent(updatedEvent);
  }

  Future<void> delete(VocelEvent deletedEvent) async {
    await eventsDataStoreService.deleteEvent(deletedEvent);
  }

  Stream<VocelEvent> get(String id) {
    return eventsDataStoreService.getEventStream(id);
  }
}
