// import 'dart:ui';
// import 'dart:math';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:vocel/common/utils/colors.dart' as constants;
//
// class Reminder {
//   final String title;
//   final String notes;
//   final DateTime? dueDate;
//   bool isCompleted;
//   bool isPin;
//
//   Reminder({
//     required this.title,
//     required this.notes,
//     this.dueDate,
//     this.isCompleted = false,
//     this.isPin = false,
//   });
// }
//
// class RemList {
//   final String name;
//
//   RemList(this.name);
// }
//
// class AnnouncementHome extends StatefulWidget {
//   const AnnouncementHome({Key? key}) : super(key: key);
//
//   @override
//   State<AnnouncementHome> createState() => _AnnouncementHomeState();
// }
//
// class _AnnouncementHomeState extends State<AnnouncementHome> {
//   final reminders = <Reminder>[
//     Reminder(title: 'Reminder 1', notes: 'This is a note.'),
//     Reminder(title: 'Reminder 2', notes: 'This is another note.', dueDate: DateTime.now().add(const Duration(days: 1))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//     Reminder(title: 'Reminder 3', notes: 'This is yet another note.', dueDate: DateTime.now().add(Duration(days: Random().nextInt(10)))),
//   ];
//
//   void showAddAnnouncementDialog(BuildContext context) async {
//     await showModalBottomSheet<void>(
//       isScrollControlled: true,
//       elevation: 5,
//       context: context,
//       builder: (BuildContext context) {
//         return AddTripBottomSheet();
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(constants.primaryColorDark),
//         onPressed: () async {
//           showAddAnnouncementDialog(context);
//           final reminder = Reminder(title: 'Here is a new reminder', notes: '');
//           setState(() {
//             reminders.add(reminder);
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: buildReminders(),
//     );
//   }
//
//   Center buildReminders() {
//     reminders.sort((a, b) {
//       if (a.isCompleted && !b.isCompleted) {
//         return 1; // b should come before a
//       } else if (!a.isCompleted && b.isCompleted) {
//         return -1; // a should come before b
//       } else {
//         // Both have same isCompleted values, compare isPin
//         if (a.isPin && !b.isPin) {
//           return -1; // a should come before b
//         } else if (!a.isPin && b.isPin) {
//           return 1; // b should come before a
//         } else {
//           // Both are either pinned or not pinned
//           if (a.dueDate == null && b.dueDate == null) {
//             return 0;
//           } else if (a.dueDate == null) {
//             return 1;
//           } else if (b.dueDate == null) {
//             return -1;
//           } else {
//             return a.dueDate!.compareTo(b.dueDate!);
//           }
//         }
//       }
//     });
//     return Center(
//       child: ListView.builder(
//         itemCount: reminders.length,
//         itemBuilder: (context, index) {
//           final reminder = reminders[index];
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             padding: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: reminder.isCompleted ? Colors.grey.shade300
//                       .withOpacity(0.5) : (reminder.isPin ? const Color(
//                       constants.primaryDarkTeal).withOpacity(0.5) : const Color(
//                       constants.primaryRegularTeal).withOpacity(0.2)),
//                   spreadRadius: 2,
//                   blurRadius: 3,
//                   offset: reminder.isPin ? const Offset(2, 2) : const Offset(
//                       0, 1),
//                 ),
//               ],
//               gradient: reminder.isPin ? const LinearGradient(
//                 colors: [
//                   Colors.white,
//                   Colors.white38,
//                   Color(constants.primaryLightTeal)
//                 ],
//                 begin: Alignment(-0.2, -0.8),
//                 end: Alignment(1, 1),
//                 stops: [0.0, 0.95, 1],
//               ) : null,
//             ),
//             child: ListTile(
//               leading: IconButton(onPressed: () {
//                 setState(() {
//                   reminder.isPin = !reminder.isPin;
//                 });
//               },
//                   icon: reminder.isPin
//                       ? const Icon(Icons.push_pin)
//                       : const Icon(Icons.push_pin_outlined)),
//               title: Row(
//                 children: [
//                   Expanded(
//                     child: Opacity(
//                       opacity: reminder.isCompleted ? 0.5 : 1.0,
//                       child: Text(
//                         reminder.title,
//                         style: TextStyle(
//                           decoration: reminder.isCompleted ? TextDecoration
//                               .lineThrough : null,
//                           color: reminder.isCompleted ? Colors.grey : Colors
//                               .black,
//                           fontWeight: reminder.isCompleted
//                               ? FontWeight.normal
//                               : FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     child: Opacity(
//                       opacity: reminder.isCompleted ? 0.5 : 1.0,
//                       child: Text(
//                         reminder.dueDate != null ? DateFormat.yMMMd().format(
//                             reminder.dueDate!) : 'No date set',
//                         style: TextStyle(
//                           decoration: reminder.isCompleted ? TextDecoration
//                               .lineThrough : null,
//                           color: reminder.isCompleted ? Colors.grey : Colors
//                               .black,
//                           fontWeight: reminder.isCompleted
//                               ? FontWeight.normal
//                               : FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     onTap: () async {
//                       // TODO: Implement editing the due date of the reminder
//                     },
//                     onDoubleTap: () async {
//                       // TODO: Implement clearing the due date of the reminder
//                     },
//                   )
//                 ],
//               ),
//               subtitle: reminder.notes.isNotEmpty ? Text(reminder.notes) : null,
//               trailing: GestureDetector(
//                 child: reminder.isCompleted
//                     ? const Icon(Icons.check_box)
//                     : const Icon(Icons.check_box_outline_blank),
//                 onTap: () async {
//                   setState(() {
//                     reminder.isCompleted = !reminder.isCompleted;
//                   });
//                 },
//               ),
//               onLongPress: () async {
//                 setState(() {
//                   // TODO: might delete the reminder from the database?
//                   reminders.remove(reminder);
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
// }