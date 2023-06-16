import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/ui/home_page/add_announcement_bottomsheet.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:amplify_core/amplify_core.dart';

class AnnouncementHome extends HookConsumerWidget {
  const AnnouncementHome({Key? key, required this.showEdit}) : super(key: key);

  final bool showEdit;

  void showAddAnnouncementDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddTripBottomSheet();
      },
    );
  }

  Future<bool> calculateFinalTesting() async {
    return await verifyAdminAccess();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibilityButton = useState(false);

    /// why using [key] in the useEffect method.
    // The [key] in the useEffect hook's dependency list specifies that
    // the effect should be triggered whenever the key property changes.
    // It allows you to recalculate or update the visibility based on the
    // new value of key. If you don't need to track changes in the key property,
    // you can omit it from the dependency list to ensure the effect runs only
    // once during the widget's initial build.

    useEffect(() {
      calculateFinalTesting().then((newVisibility) {
        if (newVisibility != visibilityButton.value) {
          visibilityButton.value = newVisibility;
        }
      });
    }, [key]);

    final Orientation orientation = MediaQuery.of(context).orientation;
    final AsyncValue<List<Announcement?>> reminderValue =
        ref.watch(tripsListStreamProvider);

    /// if use checkValidFuture
    // floatingActionButton: FutureBuilder<bool>(
    //   future: checkValid(keyString),
    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // While the future is still loading, you can show a progress indicator or any placeholder widget.
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // If an error occurred during the future execution, you can handle it accordingly.
    //       return Text('Error: ${snapshot.error}');
    //     } else {
    //       final bool shouldShowFloatingActionButton = snapshot.data ?? false;
    //
    //       return Visibility(
    //         visible: shouldShowFloatingActionButton,
    //         child: FloatingActionButton(
    //           backgroundColor: const Color(constants.primaryColorDark),
    //           onPressed: () async {
    //             showAddAnnouncementDialog(context);
    //           },
    //           child: const Icon(Icons.add),
    //         ),
    //       );
    //     }
    //   },
    // ),

    return Scaffold(
        floatingActionButton: Visibility(
          visible: showEdit,
          child: FloatingActionButton(
            heroTag: "EventFloatingActionButton",
            backgroundColor: const Color(constants.primaryColorDark),
            onPressed: () async {
              showAddAnnouncementDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: reminderValue.when(
            data: (announcement) => announcement.isEmpty
                ? const Center(
                    child: Text("No Announcement"),
                  )
                :

                // it is a trick:
                // We use the whereType method to filter out the null elements and only
                // keep the non-null Trip objects. Finally, we call toList() to convert
                // the filtered iterable into a List<Trip>.
                buildReminders(
                    announcement.whereType<Announcement>().toList(), ref),
            error: (e, st) => const Center(
                  child: Text('Error Here'),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }

  Center buildReminders(List<Announcement> reminders, WidgetRef ref) {
    reminders.sort((a, b) {
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
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Container(
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
                              ref.read(tripControllerProvider).delete(reminder);
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog and delete
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
                              ref
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
                      ref.read(tripControllerProvider).pinMe(
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
                        color:
                            reminder.isCompleted ? Colors.grey : Colors.black,
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
                        color:
                            reminder.isCompleted ? Colors.grey : Colors.black,
                        fontWeight: reminder.isCompleted
                            ? FontWeight.normal
                            : FontWeight.w300,
                      ),
                    ),
                  ),
                  trailing: Text(
                    reminder.createdAt == null
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
          );
        },
      ),
    );
  }
}
