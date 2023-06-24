import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/features/announcement/data/event_repository.dart';
import 'package:vocel/models/VocelEvent.dart';

final eventControllerProvider = Provider<EventController>((ref) {
  return EventController(ref);
});

class EventController {
  EventController(this.ref);

  final Ref ref;

  Future<void> uploadFile(File file, VocelEvent event) async {
    final fileKey = await ref.read(storageServiceProvider).uploadFile(file);
    if (fileKey != null) {
      final imageUrl =
          await ref.read(storageServiceProvider).getImageUrl(fileKey);
      final updatedEvent =
          event.copyWith(eventImageKey: fileKey, eventImageUrl: imageUrl);
      await ref.read(eventsRepositoryProvider).update(updatedEvent);
      ref.read(storageServiceProvider).resetUploadProgress();
    }
  }

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }

  Future<void> edit(VocelEvent updatedEvent) async {
    final eventsRepository = ref.read(eventsRepositoryProvider);
    await eventsRepository.update(updatedEvent);
  }

  Future<void> delete(VocelEvent deletedEvent) async {
    final eventsRepository = ref.read(eventsRepositoryProvider);
    await eventsRepository.delete(deletedEvent);
  }
}
