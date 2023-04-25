// import 'package:vocel/features/widget/custom_event_notification.dart';
// import 'package:vocel/features/widget/custom_meeting_notification.dart';
// import 'package:flutter/material.dart';
// import 'package:vocel/common/utils/colors.dart' as constants;
//
// class NotificationWidget extends StatefulWidget {
//   const NotificationWidget({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationWidget> createState() => _NotificationWidgetState();
// }
//
// class _NotificationWidgetState extends State<NotificationWidget> {
//   final List<String> newItem = ["liked", "follow"];
//
//   final List<String> todayItem = ["follow", "liked", "liked"];
//
//   final List<String> oldestItem = ["follow", "follow", "liked", "liked"];
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           leading: SizedBox(
//             height: 60,
//             width: 60,
//             child: FloatingActionButton(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               child: const Icon(
//                 Icons.arrow_back_rounded,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           title: const Text(
//             "Notification",
//           ),
//           actions: [],
//           centerTitle: false,
//           elevation: 2,
//           backgroundColor: const Color(constants.primaryColorDark),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "New",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: newItem.length,
//                 itemBuilder: (context, index) {
//                   return newItem[index] == "follow"
//                       ? const CustomEventNotification()
//                       : const MeetingNotification();
//                 },
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "Today",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: todayItem.length,
//                 itemBuilder: (context, index) {
//                   return todayItem[index] == "follow"
//                       ? const CustomEventNotification()
//                       : const MeetingNotification();
//                 },
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "Oldest",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: oldestItem.length,
//                 itemBuilder: (context, index) {
//                   return oldestItem[index] == "follow"
//                       ? const CustomEventNotification()
//                       : const MeetingNotification();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
