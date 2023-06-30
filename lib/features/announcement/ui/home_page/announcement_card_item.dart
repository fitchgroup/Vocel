import 'package:amplify_core/src/types/temporal/temporal_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:vocel/features/announcement/ui/home_page/add_announcement_comment_bottonsheet.dart';
import 'package:vocel/features/announcement/ui/home_page/announcement_comment.dart';
import 'package:vocel/models/ModelProvider.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class AnnouncementCard extends StatefulWidget {
  final thisAnnouncement;
  final callbackPins;
  final callbackLikes;
  final currentPerson;
  final index;

  const AnnouncementCard(
      {Key? key,
      required this.thisAnnouncement,
      required this.callbackLikes,
      required this.currentPerson,
      required this.index,
      required this.callbackPins})
      : super(key: key);

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  late ValueNotifier<bool> liked;
  late List<String> likeList;
  late List<String> commentList;

  late bool showing = false;

  void showAddCommentDialog(BuildContext context, String userEmail,
      Announcement thisAnnouncement) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddAnnouncementCommentBottomSheet(
          userEmail: userEmail,
          relatedAnnouncement: thisAnnouncement,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    liked = ValueNotifier(
      (widget.thisAnnouncement as Announcement).likes != null &&
          (widget.thisAnnouncement as Announcement)
              .likes!
              .contains(widget.currentPerson),
    );

    likeList = (widget.thisAnnouncement as Announcement).likes != null
        ? List<String>.from((widget.thisAnnouncement as Announcement).likes!)
        : [];
    commentList = (widget.thisAnnouncement as Announcement).comments != null
        ? List<String>.from((widget.thisAnnouncement as Announcement).comments!)
        : [];
  }

  void changingLikes() async {
    final bool newLiked = !liked.value;
    liked.value = newLiked;
    if (newLiked) {
      likeList.add(widget.currentPerson);
    } else {
      likeList.remove(widget.currentPerson);
    }
  }

  void changingComments() {
    setState(() {
      commentList = (widget.thisAnnouncement as Announcement).comments != null
          ? List<String>.from(
              (widget.thisAnnouncement as Announcement).comments!)
          : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
              color: widget.thisAnnouncement.isCompleted
                  ? Colors.grey
                  : Color(constants.shiftColor[widget.index % 4]),
              width: 6.0,
            )),
            color: Colors
                .grey[200], // Add a background color to mimic blockquote style
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(2.0),
                bottomRight: Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.thisAnnouncement.isCompleted
                      ? Colors.grey.shade300.withOpacity(0.2)
                      : (widget.thisAnnouncement.isPinned
                          ? const Color(constants.primaryDarkTeal)
                              .withOpacity(0.45)
                          : const Color(constants.primaryRegularTeal)
                              .withOpacity(0.2)),
                  spreadRadius: 1.5,
                  blurRadius: 1,
                  offset: widget.thisAnnouncement.isPinned
                      ? const Offset(1, 0)
                      : const Offset(1, 0),
                ),
              ],
              gradient: widget.thisAnnouncement.isPinned
                  ? LinearGradient(
                      colors: [
                        Colors.white,
                        const Color(constants.primaryColorDark)
                            .withOpacity(0.8),
                        const Color(constants.primaryDarkTeal),
                      ],
                      begin: const Alignment(-0.2, -0.8),
                      end: const Alignment(1, 1),
                      stops: [0.0, 0.85, 1],
                    )
                  : null,
            ),
            child: ListTile(
              leading: IconButton(
                onPressed: () async {
                  await widget.callbackPins(widget.thisAnnouncement);
                },
                icon: widget.thisAnnouncement.isPinned
                    ? const Icon(Icons.push_pin)
                    : const Icon(Icons.push_pin_outlined),
              ),
              title: Opacity(
                opacity: widget.thisAnnouncement.isCompleted ? 0.5 : 1.0,
                child: Text(
                  widget.thisAnnouncement.tripName,
                  style: TextStyle(
                    decoration: widget.thisAnnouncement.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: widget.thisAnnouncement.isCompleted
                        ? Colors.grey
                        : Colors.black,
                    fontWeight: widget.thisAnnouncement.isCompleted
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Opacity(
                opacity: widget.thisAnnouncement.isCompleted ? 0.2 : 1.0,
                child: Text(
                  // DateFormat('MMMM d, yyyy').format(reminder.endDate.getDateTime()),
                  widget.thisAnnouncement.description,
                  style: TextStyle(
                    decoration: widget.thisAnnouncement.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: widget.thisAnnouncement.isCompleted
                        ? Colors.grey
                        : Colors.black,
                    fontWeight: widget.thisAnnouncement.isCompleted
                        ? FontWeight.normal
                        : FontWeight.w300,
                  ),
                ),
              ),
              trailing: Text(
                widget.thisAnnouncement.createdAt != null
                    ? DateFormat('MMM d, yy').format(
                        widget.thisAnnouncement.createdAt!.getDateTimeInUtc())
                    : "",
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: showing,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() async {
                                changingLikes();
                                await widget.callbackLikes(
                                    widget.thisAnnouncement,
                                    widget.currentPerson);
                                showing = false;
                              });
                            },
                            icon: ValueListenableBuilder<bool>(
                              valueListenable: liked,
                              builder: (BuildContext context, bool value,
                                  Widget? child) {
                                return Icon(
                                  value
                                      ? Icons.favorite
                                      : Icons.favorite_outline_rounded,
                                  color: value ? Colors.red : Colors.grey,
                                  size: 25,
                                );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              showAddCommentDialog(
                                  context,
                                  widget.currentPerson,
                                  widget.thisAnnouncement);
                              changingComments();
                              showing = false;
                            },
                            icon: const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showing = !showing;
                  });
                },
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        if (likeList.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Liked by ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        if (likeList.length <= 3)
                          TextSpan(
                            text: likeList.join(", "),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          TextSpan(
                            text: likeList.sublist(0, 3).join(", "),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          const TextSpan(
                            text: ' and',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        if (likeList.length > 3)
                          TextSpan(
                            text: ' ${likeList.length - 3} others',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        AnnouncementCommentList(
          announcementId: widget.thisAnnouncement,
        )
      ],
    );
  }
}
