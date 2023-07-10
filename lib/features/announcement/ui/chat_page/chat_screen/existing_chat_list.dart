import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/message_repository.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_screen/existing_chatting_card.dart';
import 'package:vocel/models/ModelProvider.dart';

class ExistingChatList extends HookConsumerWidget {
  final String myInfo;

  ExistingChatList({
    Key? key,
    required this.myInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<VocelMessage?>> messageHistory =
        ref.watch(messageListStreamProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: messageHistory.when(
          data: (thisMessages) => thisMessages.isEmpty
              ? const Center(
                  child: Text("No Messages"),
                )
              : buildMessages(
                  thisMessages
                      .whereType<VocelMessage>()
                      .where((message) =>
                          message.sender == myInfo ||
                          message.receiver == myInfo)
                      .toList(),
                  context,
                  ref),
          error: (e, st) => const Center(
            child: Text('Error Here'),
          ),
          loading: () => const Center(
            child: Text('Loading Message'),
          ),
        ),
      ),
    );
  }

  ListView buildMessages(
      List<VocelMessage> messages, BuildContext context, WidgetRef ref) {
    Map<String, List<VocelMessage>> messageGroups = {};
    for (var message in messages) {
      var otherPerson =
          message.sender == myInfo ? message.receiver : message.sender;
      if (!messageGroups.containsKey(otherPerson)) {
        messageGroups[otherPerson] = [];
      }
      messageGroups[otherPerson]?.add(message);
    }

    // Sorting message groups
    List<String> sortedKeys = messageGroups.keys.toList()

      ///  The .. allows us to call sort directly on the newly created list, without needing to create an intermediate variable.
      ..sort((a, b) {
        DateTime? lastMessageTimeA = messageGroups[a]
            ?.map((m) =>
                m.updatedAt?.getDateTimeInUtc() ??
                m.createdAt?.getDateTimeInUtc())
            .reduce((value, element) =>
                value?.isAfter(element!) == true ? value : element);

        DateTime? lastMessageTimeB = messageGroups[b]
            ?.map((m) =>
                m.updatedAt?.getDateTimeInUtc() ??
                m.createdAt?.getDateTimeInUtc())
            .reduce((value, element) =>
                value?.isAfter(element!) == true ? value : element);

        return -lastMessageTimeA!.compareTo(lastMessageTimeB!);
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final messageGroup = messageGroups[key]!;
        final otherPerson = key;
        final latestMessage = messageGroup.reduce((curr, next) =>
            (curr.updatedAt ?? curr.createdAt)!.getDateTimeInUtc().isAfter(
                    next.updatedAt?.getDateTimeInUtc() ??
                        next.createdAt!.getDateTimeInUtc())
                ? curr
                : next);
        return ExistingChattingCard(
          myInfo: myInfo,
          otherPersonName: otherPerson,
          latestMessageContent: latestMessage.content,
          messages: messageGroup,
        );
      },
    );
  }
}
