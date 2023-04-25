// import 'package:flutter/material.dart';
//
// class ForumPost extends StatefulWidget {
//   @override
//   State<ForumPost> createState() => _ForumPostState();
// }
//
// class _ForumPostState extends State<ForumPost> {
//   final Post post;
//
//   PostWidget({required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             post.title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20.0,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             'Posted by ${post.author} on ${post.date}',
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Text(
//             post.body,
//             style: TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }