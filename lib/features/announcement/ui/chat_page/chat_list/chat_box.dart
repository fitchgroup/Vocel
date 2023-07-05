import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/sender_receiver.dart';
import 'package:vocel/features/announcement/data/message_repository.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_message.dart';
import 'package:vocel/features/announcement/ui/chat_page/chat_list/texting_bar.dart';
import 'package:vocel/models/ModelProvider.dart';

class ChatPage extends HookConsumerWidget {
  final String myInfo;
  final String theirInfo;
  final String title;

  ChatPage({
    Key? key,
    required this.myInfo,
    required this.theirInfo,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final MessageProviderParams senderReceiver =
    //     MessageProviderParams(myInfo, theirInfo);

    final AsyncValue<List<VocelMessage?>> messageHistory =
        ref.watch(messageListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Container(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 6, // Allocate 65% of the available height
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      theirInfo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Pangolin",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4, // Allocate 35% of the available height
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: messageHistory.when(
                data: (thisMessages) => thisMessages.isEmpty
                    ? const Center(
                        child: Text("No Messages"),
                      )
                    : buildMessages(
                        thisMessages
                            .whereType<VocelMessage>()
                            .where((message) =>
                                message.sender == myInfo &&
                                message.receiver == theirInfo)
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
          ),
          TextingBar(senderInfo: myInfo, receiverInfo: theirInfo)
        ],
      ),
    );
  }

  Center buildMessages(
      List<VocelMessage> messages, BuildContext context, WidgetRef ref) {
    messages.sort((a, b) {
      DateTime? comparedTimeFromA;
      DateTime? comparedTimeFromB;
      if (a.updatedAt != null) {
        comparedTimeFromA = a.updatedAt!.getDateTimeInUtc();
      } else if (a.createdAt != null) {
        comparedTimeFromA = a.createdAt!.getDateTimeInUtc();
      }

      if (b.updatedAt != null) {
        comparedTimeFromB = b.updatedAt!.getDateTimeInUtc();
      } else if (b.createdAt != null) {
        comparedTimeFromB = b.createdAt!.getDateTimeInUtc();
      }

      if (comparedTimeFromA == null && comparedTimeFromB != null) {
        return 1; // a should come before b
      } else if (comparedTimeFromB == null && comparedTimeFromA != null) {
        return -1; // b should come before a
      } else if (comparedTimeFromA != null && comparedTimeFromB != null) {
        return comparedTimeFromA.compareTo(comparedTimeFromB);
      } else {
        return a.sender.compareTo(b.sender);
      }
    });

    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final messageNeedRender = messages[index];
          return ChatCard(
              me: myInfo,
              sender: messageNeedRender.sender,
              receiver: messageNeedRender.receiver,
              content: messageNeedRender.content,
              index: index,
              messageTime: messageNeedRender.createdAt);
        },
      ),
    );
  }
}
