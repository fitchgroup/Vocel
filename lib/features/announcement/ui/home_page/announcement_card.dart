// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:vocel/common/navigation/router/routes.dart';
//
// import 'package:vocel/common/utils/colors.dart' as constants;
// import 'package:vocel/model/Trip.dart';
//
// class TripCard extends StatelessWidget {
//   const TripCard({
//     required this.trip,
//     this.imageURL,
//     super.key,
//   });
//
//   final Trip trip;
//   final String? imageURL;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         splashColor: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(15),
//         onTap: () {
//           context.goNamed(
//             AppRoute.trip.name,
//             params: {'id': trip.id},
//           );
//         },
//         child: Card(
//           clipBehavior: Clip.antiAlias,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           elevation: 5.0,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 500,
//                   alignment: Alignment.center,
//                   color: const Color(constants.primaryColorDark),
//                   child: Stack(
//                     children: [
//                       Positioned.fill(
//                         child: trip.tripImageUrl != null
//                             ? Stack(children: [
//                           const Center(
//                               child: CircularProgressIndicator()),
//                           CachedNetworkImage(
//                             errorWidget: (context, url, dynamic error) =>
//                             const Icon(Icons.error_outline_outlined),
//                             imageUrl: trip.tripImageUrl!,
//                             cacheKey: trip.tripImageKey,
//                             width: double.maxFinite,
//                             height: 500,
//                             alignment: Alignment.topCenter,
//                             fit: BoxFit.fill,
//                           ),
//                         ])
//                             : Image.asset(
//                           'images/amplify.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 16,
//                         left: 16,
//                         right: 16,
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             trip.destination,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headline5!
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(2, 8, 8, 4),
//                 child: DefaultTextStyle(
//                   softWrap: false,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.subtitle1!,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           trip.tripName,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle1!
//                               .copyWith(color: Colors.black54),
//                         ),
//                       ),
//                       Text(
//                         DateFormat('MMMM dd, yyyy')
//                             .format(trip.startDate.getDateTime()),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       Text(
//                           DateFormat('MMMM dd, yyyy')
//                               .format(trip.endDate.getDateTime()),
//                           style: const TextStyle(fontSize: 12)),
//                       const Text(
//                           "\nThis is implemented in \nfeature/trip/ui/trips_list"
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
