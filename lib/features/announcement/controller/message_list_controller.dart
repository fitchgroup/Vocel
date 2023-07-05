import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/message_repository.dart';
import 'package:vocel/models/VocelMessage.dart';

final messagesListControllerProvider = Provider<MessagesListController>((ref) {
  return MessagesListController(ref);
});

class MessagesListController {
  MessagesListController(this.ref);

  final Ref ref;

  Future<void> add({
    required String messageContent,
    required String messageSender,
    required String messageReceiver,
  }) async {
    VocelMessage message = VocelMessage(
        content: messageContent,
        sender: messageSender,
        receiver: messageReceiver);

    final messagesRepository = ref.read(messagesRepositoryProvider);

    await messagesRepository.add(message);
  }
}
