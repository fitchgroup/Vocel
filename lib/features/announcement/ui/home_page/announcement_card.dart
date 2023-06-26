import 'package:flutter/widgets.dart';
import 'package:vocel/models/ModelProvider.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/models/Announcement.dart';

class AnnouncementCard extends StatefulWidget {
  const AnnouncementCard({
    super.key,
    required this.reminders,
    required this.ref,
    required this.context,
  });

  final List<Announcement> reminders;
  final WidgetRef ref;
  final BuildContext context;

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  late List<bool> showingList = [];

  @override
  void initState() {
    super.initState();
    showingList = List<bool>.filled(widget.reminders.length, false);
  }

  @override
  void didUpdateWidget(AnnouncementCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reminders.length != showingList.length) {
      showingList = List<bool>.filled(widget.reminders.length, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.reminders.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) {
        return 1; // b should come before a
      } else if (!a.isCompleted && b.isCompleted) {
        return -1; // a should come before b
      } else {
        // Both have same isCompleted values, compare isPin
        if (a.isPinned && !b.isPinned) {
          return -1; // a should come before b
        } else if (!a.isPinned && b.isPinned) {
          return 1; // b should come before a
        } else {
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
            return -1; // a should come before b
          } else if (comparedTimeFromB == null && comparedTimeFromA != null) {
            return 1; // b should come before a
          } else if (comparedTimeFromA != null && comparedTimeFromB != null) {
            return -1 * comparedTimeFromA.compareTo(comparedTimeFromB);
          } else {
            return a.tripName.compareTo(b.tripName);
          }
        }
      }
    });
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.reminders.length,
        itemBuilder: (context, index) {
          final reminder = widget.reminders[index];
          bool showing = showingList[index];

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                    color: reminder.isCompleted
                        ? Colors.grey
                        : Color(constants.shiftColor[index % 4]),
                    width: 6.0,
                  )),
                  color: Colors.grey[
                      200], // Add a background color to mimic blockquote style
                ),
                child: Dismissible(
                  key: Key(reminder.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Show confirmation dialog for delete action
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Reminder"),
                            content: const Text(
                                "Are you sure you want to delete this reminder?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Dismiss the dialog and don't delete
                                },
                              ),
                              TextButton(
                                child: const Text("Delete"),
                                onPressed: () {
                                  widget.ref
                                      .read(tripControllerProvider)
                                      .delete(reminder);
                                  Navigator.of(context).pop(
                                      false); // Dismiss the dialog and delete
                                  showingList.removeLast();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (direction == DismissDirection.startToEnd) {
                      // Show confirmation dialog for complete action
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: reminder.isCompleted
                                ? const Text("Reset Reminder")
                                : const Text("Complete Reminder"),
                            content: reminder.isCompleted
                                ? const Text(
                                    "Are you sure you want to reset this reminder as complete?")
                                : const Text(
                                    "Are you sure you want to mark this reminder as not completed?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Dismiss the dialog and don't complete
                                },
                              ),
                              TextButton(
                                child: reminder.isCompleted
                                    ? const Text("Reset")
                                    : const Text("Complete"),
                                onPressed: () {
                                  widget.ref
                                      .read(tripControllerProvider)
                                      .completeMe(reminder);
                                  Navigator.of(context).pop(
                                      false); // Dismiss the dialog and complete
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return false;
                  },
                  background: Container(
                    color: Colors.blueGrey[600]?.withOpacity(0.4),
                    // Customize the background color for complete action
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red[800]?.withOpacity(0.6),
                    // Customize the background color for delete action
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.horizontal,
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
                          color: reminder.isCompleted
                              ? Colors.grey.shade300.withOpacity(0.2)
                              : (reminder.isPinned
                                  ? const Color(constants.primaryDarkTeal)
                                      .withOpacity(0.45)
                                  : const Color(constants.primaryRegularTeal)
                                      .withOpacity(0.2)),
                          spreadRadius: 1.5,
                          blurRadius: 1,
                          offset: reminder.isPinned
                              ? const Offset(1, 0)
                              : const Offset(1, 0),
                        ),
                      ],
                      gradient: reminder.isPinned
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
                        onPressed: () {
                          widget.ref.read(tripControllerProvider).pinMe(
                              reminder); // Assuming you have a provider notifier for toggling the pin state
                        },
                        icon: reminder.isPinned
                            ? const Icon(Icons.push_pin)
                            : const Icon(Icons.push_pin_outlined),
                      ),
                      title: Opacity(
                        opacity: reminder.isCompleted ? 0.5 : 1.0,
                        child: Text(
                          reminder.tripName,
                          style: TextStyle(
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: reminder.isCompleted
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: reminder.isCompleted
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Opacity(
                        opacity: reminder.isCompleted ? 0.2 : 1.0,
                        child: Text(
                          // DateFormat('MMMM d, yyyy').format(reminder.endDate.getDateTime()),
                          reminder.description,
                          style: TextStyle(
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: reminder.isCompleted
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: reminder.isCompleted
                                ? FontWeight.normal
                                : FontWeight.w300,
                          ),
                        ),
                      ),
                      trailing: Text(
                        reminder.createdAt != null
                            ? DateFormat('MMM d, yy')
                                .format(reminder.createdAt!.getDateTimeInUtc())
                            : "",
                      ),
                      // trailing: GestureDetector(
                      //   child: reminder.isCompleted ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                      //   onTap: () async {
                      //     ref.read(tripControllerProvider).completeMe(reminder); // Assuming you have a provider notifier for toggling the completion state
                      //   },
                      // ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                                    setState(() {
                                      showingList[index] = !showingList[index];
                                    });
                                  },
                                  icon: const Icon(Icons.favorite),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.comment),
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
                          showingList[index] = !showingList[index];
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
            ],
          );
        },
      ),
    );
  }
}
