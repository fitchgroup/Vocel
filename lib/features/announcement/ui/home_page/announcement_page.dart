import 'dart:ui';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/data/trip_repository.dart';
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/features/announcement/ui/home_page/add_announcement_bottomsheet.dart';
import 'package:vocel/model/Trip.dart';

class Reminder {
  final String title;
  final String notes;
  final DateTime? dueDate;
  bool isCompleted;
  bool isPin;

  Reminder({
    required this.title,
    required this.notes,
    this.dueDate,
    this.isCompleted = false,
    this.isPin = false,
  });
}

class RemList {
  final String name;

  RemList(this.name);
}

class AnnouncementHome extends HookConsumerWidget {
  const AnnouncementHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = useState(<Reminder>[
      Reminder(title: 'Reminder 1', notes: 'This is a note.'),
      Reminder(title: 'Reminder 2',
          notes: 'This is another note.',
          dueDate: DateTime.now().add(const Duration(days: 1))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          isPin: true,
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
      Reminder(title: 'Reminder 3',
          notes: 'This is yet another note.',
          dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
    ]);

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

    Center buildReminders(List<Trip?> reminders) {
      reminders.sort((a, b) {
        bool aCompleted = a?.isCompleted ?? false;
        bool bCompleted = b?.isCompleted ?? false;
        bool aPin = a?.isPin ?? false;
        bool bPin = b?.isPin ?? false;

        if (aCompleted && !bCompleted) {
          return 1; // b should come before a
        } else if (!aCompleted && bCompleted) {
          return -1; // a should come before b
        } else {
          // Both have same isCompleted values, compare isPin
          if (aPin && !bPin) {
            return -1; // a should come before b
          } else if (!aPin && bPin) {
            return 1; // b should come before a
          } else {
            // Both have same isPin values, compare dueDate
            if (a?.endDate == null && b?.endDate == null) {
              return 0; // no due dates for both, no ordering needed
            } else if (a?.endDate == null) {
              return 1; // b should come before a
            } else if (b?.endDate == null) {
              return -1; // a should come before b
            } else {
              return a!.endDate!.compareTo(b!.endDate!); // sort by due date
            }
          }
        }
      });

      return Center(
        child: reminders.isEmpty
            ? const Text('No reminders')
            : ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (BuildContext context, int index) {
            final reminder = reminders[index];

            return Dismissible(
              key: ValueKey(reminder),
              background: Container(
                color: Colors.white,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: const Color(constants.primaryColorDark),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Complete reminder?'),
                        content: const Text(
                            'Are you sure you want to complete this reminder?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Complete'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete reminder?'),
                        content: const Text(
                            'Are you sure you want to delete this reminder?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  // complete reminder
                  // ref.read(tripsListStreamProvider).toggleCompleted(reminder);
                } else {
                  // ref.read(tripsListStreamProvider).delete(reminder);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (reminder?.isCompleted ?? false) ? Colors.grey.shade300
                          .withOpacity(0.5) : ((reminder?.isPin ?? false) ? const Color(
                          constants.primaryDarkTeal).withOpacity(0.5) : const Color(
                          constants.primaryRegularTeal).withOpacity(0.2)),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: (reminder?.isPin ?? false) ? const Offset(2, 2) : const Offset(
                          0, 1),
                    ),
                  ],
                  gradient: (reminder?.isPin ?? false) ? const LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white38,
                      Color(constants.primaryLightTeal)
                    ],
                    begin: Alignment(-0.2, -0.8),
                    end: Alignment(1, 1),
                    stops: [0.0, 0.95, 1],
                  ) : null,
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: (reminder?.isCompleted ?? false) ? 0.5 : 1.0,
                          child: Text(
                            reminder?.tripName ?? "no name",
                            style: TextStyle(
                              decoration: (reminder?.isCompleted ?? false) ? TextDecoration
                                  .lineThrough : null,
                              color: (reminder?.isCompleted ?? false) ? Colors.grey : Colors
                                  .black,
                              fontWeight: (reminder?.isCompleted ?? false)
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Opacity(
                          opacity: (reminder?.isCompleted ?? false) ? 0.5 : 1.0,
                          child: Text(
                            reminder?.endDate != null ? DateFormat.yMMMd().format(
                                reminder!.endDate as DateTime) : 'No date set',
                            style: TextStyle(
                              decoration: (reminder?.isCompleted ?? false) ? TextDecoration
                                  .lineThrough : null,
                              color: (reminder?.isCompleted ?? false) ? Colors.grey : Colors
                                  .black,
                              fontWeight: (reminder?.isCompleted ?? false)
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () async {
                          // TODO: Implement editing the due date of the reminder
                        },
                        onDoubleTap: () async {
                          // TODO: Implement clearing the due date of the reminder
                        },
                      ),
                    ],
                  ),
                  subtitle: reminder?.description == null ? Text(reminder!.description) : null,
                  leading: IconButton(
                    icon:  (reminder?.isPin ?? false) ? const Icon(Icons.push_pin) : const Icon(Icons.push_pin_outlined),
                    color: (reminder?.isPin ?? false) ?   Colors.blueGrey.shade800 : Colors.grey, onPressed: () {
                    ref.read(tripControllerProvider).pinMe(reminder!);
                  },
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    final AsyncValue<List<Trip?>> tripsListValue = ref.watch(tripsListStreamProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(constants.primaryColorDark),
        onPressed: () async {
          showAddAnnouncementDialog(context);
          final reminder = Reminder(title: 'Here is a new reminder', notes: '');
          reminders.value = [...reminders.value, reminder];
        },
        child: const Icon(Icons.add),
      ),
      body: tripsListValue.when(
          data: (trips) => trips.isEmpty
              ? const Center(
            child: Text('No Announcement'),
          ) :
          buildReminders(trips)
          ,
          error: (e, st) => const Center(
            child: Text('Error'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          )
      )
    );


  }
}
