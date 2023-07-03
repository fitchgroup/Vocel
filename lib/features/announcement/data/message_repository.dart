import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/services/message_datastore.dart';
import 'package:vocel/models/VocelMessage.dart';

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  MessagesDataStoreService messagesDataStoreService =
  ref.read(messagesDataStoreServiceProvider);
  return MessagesRepository(messagesDataStoreService);
});

final possListStreamProvider = StreamProvider.autoDispose<
    List<VocelMessage?>>((ref) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return messagesRepository.getMessages();
});

final pastMessagesListStreamProvider =
StreamProvider.autoDispose<List<VocelMessage?>>((ref) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return messagesRepository.getPastMessages();
});

final messageProvider =
StreamProvider.autoDispose.family<VocelMessage?, String>((ref, id) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return messagesRepository.get(id);
});


class MessagesRepository {
  MessagesRepository(this.messagesDataStoreService);

  final MessagesDataStoreService messagesDataStoreService;

  Stream<List<VocelMessage>> getMessages() {
    return messagesDataStoreService.listenToMessages();
  }

  Stream<List<VocelMessage>> getPastMessages() {
    return messagesDataStoreService.listenToPastMessages();
  }

  Future<void> add(VocelMessage event) async {
    await messagesDataStoreService.addMessage(event);
  }

  Future<void> update(VocelMessage updatedEvent) async {
    await messagesDataStoreService.updateMessage(updatedEvent);
  }

  Future<void> delete(VocelMessage deletedMessage) async {
    await messagesDataStoreService.deleteMessage(deletedMessage);
  }

  Stream<VocelMessage> get(String id) {
    return messagesDataStoreService.getMessageStream(id);
  }

}
