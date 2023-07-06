import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/mutation/announcement_mutation.dart';
import 'package:vocel/features/announcement/ui/home_page/add_announcement_bottomsheet.dart';
import 'package:vocel/features/announcement/ui/home_page/announcement_card_item.dart';
import 'package:vocel/features/announcement/ui/home_page/home_navigation_bar.dart';
import 'package:vocel/models/Announcement.dart';

class HomeAnnouncementFeed extends HookConsumerWidget {
  final bool showEdit;
  final ValueChanged<String> onClickController;
  final userEmail;
  final groupOfUser;

  const HomeAnnouncementFeed(
      {Key? key,
      required this.showEdit,
      required this.onClickController,
      required this.userEmail,
      required this.groupOfUser})
      : super(key: key);

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

  /// uncomment this to enable visibilityButton
  // Future<bool> calculateFinalTesting() async {
  //   return await verifyAdminAccess();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// TODO: MAY UPDATE THIS TO CHANGE VISIBILITY SETTINGS
    // final visibilityButton = useState(false);

    /// why using [key] in the useEffect method.
    // The [key] in the useEffect hook's dependency list specifies that
    // the effect should be triggered whenever the key property changes.
    // It allows you to recalculate or update the visibility based on the
    // new value of key. If you don't need to track changes in the key property,
    // you can omit it from the dependency list to ensure the effect runs only
    // once during the widget's initial build.

    // useEffect(() {
    //   calculateFinalTesting().then((newVisibility) {
    //     if (newVisibility != visibilityButton.value) {
    //       visibilityButton.value = newVisibility;
    //     }
    //   });
    // }, [key]);

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
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TopNavigationHomeBar(
                    onClickController: onClickController,
                    current: "Announcement"),
                reminderValue.when(
                    data: (announcement) => announcement.isEmpty
                        ? const Center(
                            child: Text("No Announcement"),
                          )
                        :
                        // it is a trick:
                        // We use the whereType method to filter out the null elements and only
                        // keep the non-null Trip objects. Finally, we call toList() to convert
                        // the filtered iterable into a List<Trip>.
                        buildAnnouncements(
                            announcement.whereType<Announcement>().toList(),
                            context,
                            ref),
                    error: (e, st) => const Center(
                          child: Text('Error Here'),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ],
            ),
          ),
        ));
  }

  Center buildAnnouncements(
      List<Announcement> reminders, BuildContext context, WidgetRef ref) {
    // showingList = List<bool>.filled(reminders.length, false);
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

    void likeAnnouncement(Announcement likedAnnouncement, String editPerson) {
      ref.read(tripControllerProvider).editLikes(likedAnnouncement, editPerson);
    }

    void pinAnnouncement(Announcement pinAnnouncement) {
      ref.read(tripControllerProvider).pinMe(pinAnnouncement);
    }

    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          // bool showing = showingList[index];

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                                  ref
                                      .read(tripControllerProvider)
                                      .delete(reminder);
                                  deleteAnnouncement(reminder);

                                  /// TODO: DELETE CORRESPONDING COMMENT
                                  ///

                                  Navigator.of(context).pop(
                                      false); // Dismiss the dialog and delete
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
                  child: AnnouncementCard(
                      thisAnnouncement: reminder,
                      callbackLikes: likeAnnouncement,
                      callbackPins: pinAnnouncement,
                      currentPerson: userEmail,
                      index: index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
