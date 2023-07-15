import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/ModelProvider.dart';
import 'package:vocel/models/VocelMessage.dart';

final messagesDataStoreServiceProvider =
    Provider<MessagesDataStoreService>((ref) {
  final service = MessagesDataStoreService();
  return service;
});

class MessagesDataStoreService {
  MessagesDataStoreService();

  Stream<List<VocelMessage>> listenToAllMessages(
      String sender, String receiver) {
    return Amplify.DataStore.observeQuery(VocelMessage.classType)
        .map((querySnapshot) => querySnapshot.items
            .where((message) =>
                message.sender ==
                sender /** && message.receiver == receiver **/)
            .toList())
        .handleError((error) {
      debugPrint('listenToAllMessages: $error');
    });
  }

  Stream<List<VocelMessage>> listenToMessages() {
    return Amplify.DataStore.observeQuery(
      VocelMessage.classType,
    ).map((message) => message.items.toList()).handleError(
      (error) {
        debugPrint('listenToMessages: A Stream error happened');
      },
    );
  }

  Stream<List<VocelMessage>> listenToPastMessages() {
    return Amplify.DataStore.observeQuery(
      VocelMessage.classType,
      sortBy: [VocelMessage.CONTENT.ascending()],
    )
        .map((event) => event.items
            // .where((element) =>
            //     element.createdAt!.getDateTimeInUtc().isBefore(DateTime.now()))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToMessages: A Stream error happened');
      },
    );
  }

  Stream<VocelMessage> getMessageStream(String id) {
    final messageStream = Amplify.DataStore.observeQuery(VocelMessage.classType,
            where: VocelMessage.ID.eq(id))
        .map((message) => message.items.toList().single);

    return messageStream;
  }

  Future<void> addMessage(VocelMessage event) async {
    try {
      // Post event2 =
      //     Post(postAuthor: event.receiver, postContent: event.content);
      await Amplify.DataStore.save(event);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteMessage(VocelMessage event) async {
    try {
      await Amplify.DataStore.delete(event);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> updateMessage(VocelMessage updatedMessage) async {
    try {
      final messagesWithId = await Amplify.DataStore.query(
        VocelMessage.classType,
        where: VocelMessage.ID.eq(updatedMessage.id),
      );

      final oldMessage = messagesWithId.first;
      final newMessage = oldMessage.copyWith(
        content: updatedMessage.content,
        messageImageUrl: updatedMessage.messageImageUrl,
        messageImageKey: updatedMessage.messageImageKey,
        attachedLink: updatedMessage.attachedLink,
        sender: updatedMessage.sender,
        receiver: updatedMessage.receiver,
      );

      await Amplify.DataStore.save(newMessage);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
