import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/sender_receiver.dart';
import 'package:vocel/features/announcement/services/message_datastore.dart';
import 'package:vocel/models/VocelMessage.dart';

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  MessagesDataStoreService messagesDataStoreService =
      ref.read(messagesDataStoreServiceProvider);
  return MessagesRepository(messagesDataStoreService);
});

final messageAllListStreamProvider = StreamProvider.autoDispose
    .family<List<VocelMessage>, MessageProviderParams>((ref, params) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return messagesRepository.getAllMessages(params.sender, params.receiver);
});

final messageListStreamProvider =
    StreamProvider.autoDispose<List<VocelMessage?>>((ref) {
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

  Stream<List<VocelMessage>> getAllMessages(String sender, String receiver) {
    return messagesDataStoreService.listenToAllMessages(sender, receiver);
  }

  Stream<List<VocelMessage>> getMessages() {
    return messagesDataStoreService.listenToMessages();
  }

  Stream<List<VocelMessage>> getPastMessages() {
    return messagesDataStoreService.listenToPastMessages();
  }

  Future<void> add(VocelMessage message) async {
    await messagesDataStoreService.addMessage(message);
  }

  Future<void> update(VocelMessage updatedMessage) async {
    await messagesDataStoreService.updateMessage(updatedMessage);
  }

  Future<void> delete(VocelMessage deletedMessage) async {
    await messagesDataStoreService.deleteMessage(deletedMessage);
  }

  Stream<VocelMessage> get(String id) {
    return messagesDataStoreService.getMessageStream(id);
  }
}
