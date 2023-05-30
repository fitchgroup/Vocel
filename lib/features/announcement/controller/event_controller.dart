import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/features/announcement/data/event_repository.dart';
import 'package:vocel/models/Event.dart';

final eventControllerProvider = Provider<EventController>((ref) {
  return EventController(ref);
});

class EventController {
  EventController(this.ref);
  final Ref ref;

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }


  Future<void> edit(Event updatedEvent) async {
    final eventsRepository = ref.read(eventsRepositoryProvider);
    await eventsRepository.update(updatedEvent);
  }

  Future<void> delete(Event deletedEvent) async {
    final eventsRepository = ref.read(eventsRepositoryProvider);
    await eventsRepository.delete(deletedEvent);
  }

}
