import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/features/announcement/data/message_repository.dart';
import 'package:vocel/models/VocelMessage.dart';


final messageControllerProvider = Provider<MessageController>((ref) {
  return MessageController(ref);
});

class MessageController {
  MessageController(this.ref);

  final Ref ref;

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }

  Future<void> edit(VocelMessage updatedMessage) async {
    final messagesRepository = ref.read(messagesRepositoryProvider);
    await messagesRepository.update(updatedMessage);
  }

  Future<void> delete(VocelMessage deletedMessage) async {
    final messagesRepository = ref.read(messagesRepositoryProvider);
    await messagesRepository.delete(deletedMessage);
  }

}
