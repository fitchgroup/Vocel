import 'package:amplify_core/src/types/temporal/temporal_datetime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class ChatCard extends StatefulWidget {
  final String me;
  final String sender;
  final String receiver;
  final String content;
  final String? messageImageUrl;
  final String? messageImageKey;
  final String? attachedLink;
  final int index;
  final TemporalDateTime? messageTime;

  const ChatCard({
    required this.me,
    required this.sender,
    required this.receiver,
    required this.content,
    this.messageImageUrl,
    this.messageImageKey,
    this.attachedLink,
    required this.index,
    required this.messageTime,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    final isSentMessage = widget.me == widget.sender;

    return Row(
      mainAxisAlignment:
          isSentMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isSentMessage)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SentMessageWidget(
                  body: widget.content,
                  caption: widget.sender,
                  linkTitle: widget.attachedLink ?? '',
                  linkDescription: '',
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.messageTime != null
                        ? DateFormat('MM-d HH:mm').format(
                            widget.messageTime!.getDateTimeInUtc().toLocal())
                        : "",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        if (!isSentMessage)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReceivedMessageWidget(
                  body: widget.content,
                  caption: widget.sender,
                  linkTitle: widget.attachedLink ?? '',
                  linkDescription: '',
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.messageTime != null
                        ? DateFormat('MM-d HH:mm').format(
                            widget.messageTime!.getDateTimeInUtc().toLocal())
                        : "",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ReceivedMessageWidget extends StatelessWidget {
  final String body;
  final String caption;
  final String linkTitle;
  final String linkDescription;

  const ReceivedMessageWidget({
    required this.body,
    required this.caption,
    required this.linkTitle,
    required this.linkDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  body,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                  ),
                ),
              ),
              if (linkTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        linkTitle,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        linkDescription,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SentMessageWidget extends StatelessWidget {
  final String body;
  final String caption;
  final String linkTitle;
  final String linkDescription;

  const SentMessageWidget({
    required this.body,
    required this.caption,
    required this.linkTitle,
    required this.linkDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          decoration: const BoxDecoration(
            color: Color(constants.primaryLightTeal),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  body,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                  ),
                ),
              ),
              if (linkTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        linkTitle,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        linkDescription,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
