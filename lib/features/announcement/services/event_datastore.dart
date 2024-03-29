import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/VocelEvent.dart';

/// The code is an implementation of a EventsDataStoreService class, which serves
/// as a data access service for managing events using Amplify DataStore.

final eventsDataStoreServiceProvider = Provider<EventsDataStoreService>((ref) {
  final service = EventsDataStoreService();
  return service;
});

class EventsDataStoreService {
  EventsDataStoreService();

  /// listenToEvents: This method listens to changes in the events stored in the
  /// DataStore and returns a stream of events. It applies a filter to only include
  /// events with a start time in the future.

  Stream<List<VocelEvent>> listenToEvents() {
    return Amplify.DataStore.observeQuery(
      VocelEvent.classType,
      sortBy: [VocelEvent.STARTTIME.ascending()],
    )
        .map((event) => event.items
            .where((element) =>

                /// purge events after the event pass three months
                element.startTime.getDateTimeInUtc().isAfter(DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 3,
                    DateTime.now().day)))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToEvents: A Stream error happened');
      },
    );
  }

  /// listenToPastEvents: This method is similar to listenToEvents, but it returns
  /// a stream of events that have already occurred. It applies a filter to only include
  /// events with a start time in the past.

  Stream<List<VocelEvent>> listenToPastEvents() {
    return Amplify.DataStore.observeQuery(
      VocelEvent.classType,
      sortBy: [VocelEvent.STARTTIME.ascending()],
    )
        .map((event) => event.items
            .where((element) =>
                element.startTime.getDateTimeInUtc().isBefore(DateTime.now()))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToEvents: A Stream error happened');
      },
    );
  }

  /// getEventStream: This method returns a stream for a specific event with the given id.
  /// It uses the observeQuery method to observe changes to the event in the DataStore.

  Stream<VocelEvent> getEventStream(String id) {
    final eventStream = Amplify.DataStore.observeQuery(VocelEvent.classType,
            where: VocelEvent.ID.eq(id))
        .map((event) => event.items.toList().single);

    return eventStream;
  }

  /// addEvent: This method adds a new event to the DataStore by calling the save
  /// method of Amplify DataStore.

  Future<void> addEvent(VocelEvent event) async {
    try {
      await Amplify.DataStore.save(event);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// deleteEvent: This method deletes an existing event from the DataStore by calling
  /// the delete method of Amplify DataStore.

  Future<void> deleteEvent(VocelEvent event) async {
    try {
      await Amplify.DataStore.delete(event);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// updateEvent: This method updates an existing event in the DataStore by querying
  /// for the event with the specified id, creating a new event object with the updated
  /// fields, and then saving the updated event to the DataStore.

  Future<void> updateEvent(VocelEvent updatedEvent) async {
    try {
      final eventsWithId = await Amplify.DataStore.query(
        VocelEvent.classType,
        where: VocelEvent.ID.eq(updatedEvent.id),
      );

      final oldEvent = eventsWithId.first;
      final newEvent = oldEvent.copyWith(
        eventTitle: updatedEvent.eventTitle,
        eventLocation: updatedEvent.eventLocation,
        eventDescription: updatedEvent.eventDescription,
        startTime: updatedEvent.startTime,
        duration: updatedEvent.duration,
        eventImageKey: updatedEvent.eventImageKey,
        eventImageUrl: updatedEvent.eventImageUrl,
      );

      await Amplify.DataStore.save(newEvent);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
