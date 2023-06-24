// import 'dart:async';
//
// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/foundation.dart';
// import 'package:vocel/models/Announcement.dart';
//
// /// TODO: post instead of announcement?
// // Future<void> createAnnouncement() async {
// //   try {
// //     final announcement = Announcement(
// //         tripName: 'old Trip name',
// //         description: '',
// //         startDate: TemporalDate(DateTime.now()),
// //         endDate: TemporalDate(DateTime.now()),
// //         isCompleted: false,
// //         isPinned: false);
// //     final request = ModelMutations.create(announcement);
// //     final response = await Amplify.API.mutate(request: request).response;
// //
// //     final createdAnnouncement = response.data;
// //     if (createdAnnouncement == null) {
// //       mutationDebuggingPrint('errors: ${response.errors}');
// //       return;
// //     }
// //     mutationDebuggingPrint(
// //         'Mutation result: ${createdAnnouncement.toJson().toString()}');
// //   } on ApiException catch (e) {
// //     mutationDebuggingPrint('Mutation failed: $e');
// //   }
// // }
//
// Future<void> updateAnnouncement(Announcement originalAnnouncement) async {
//   final announcementWithNewName =
//       originalAnnouncement.copyWith(tripName: "new Trip name");
//
//   final request = ModelMutations.update(announcementWithNewName);
//   final response = await Amplify.API.mutate(request: request).response;
//   mutationDebuggingPrint('Response: $response');
// }
//
// Future<void> deleteAnnouncement(Announcement announcementToDelete) async {
//   final request = ModelMutations.delete(announcementToDelete);
//   final response = await Amplify.API.mutate(request: request).response;
//   mutationDebuggingPrint('Response: $response');
// }
//
// Future<Announcement?> queryItem(Announcement queriedAnnouncement) async {
//   try {
//     final request = ModelQueries.get(
//       Announcement.classType,
//       queriedAnnouncement.modelIdentifier,
//     );
//     final response = await Amplify.API.query(request: request).response;
//     final announcement = response.data;
//     if (announcement == null) {
//       mutationDebuggingPrint('errors: ${response.errors}');
//     }
//     return announcement;
//   } on ApiException catch (e) {
//     mutationDebuggingPrint('Query failed: $e');
//     return null;
//   }
// }
//
// Future<List<Announcement?>> queryListItems() async {
//   try {
//     final request = ModelQueries.list(Announcement.classType);
//     final response = await Amplify.API.query(request: request).response;
//
//     final announcements = response.data?.items;
//     if (announcements == null) {
//       mutationDebuggingPrint('errors: ${response.errors}');
//       return const [];
//     }
//     return announcements;
//   } on ApiException catch (e) {
//     mutationDebuggingPrint('Query failed: $e');
//     return const [];
//   }
// }
//
// const limit = 100;
//
// Future<List<Announcement?>> queryPaginatedListItems() async {
//   final firstRequest =
//       ModelQueries.list<Announcement>(Announcement.classType, limit: limit);
//   final firstResult = await Amplify.API.query(request: firstRequest).response;
//   final firstPageData = firstResult.data;
//
//   // Indicates there are > 100 announcements and you can get the request for the next set.
//   if (firstPageData?.hasNextResult ?? false) {
//     final secondRequest = firstPageData!.requestForNextResult;
//     final secondResult =
//         await Amplify.API.query(request: secondRequest!).response;
//     return secondResult.data?.items ?? <Announcement?>[];
//   } else {
//     return firstPageData?.items ?? <Announcement?>[];
//   }
// }
//
// Stream<GraphQLResponse<Announcement>> subscribe() {
//   final subscriptionRequest =
//       ModelSubscriptions.onCreate(Announcement.classType);
//   final Stream<GraphQLResponse<Announcement>> operation = Amplify.API
//       .subscribe(
//         subscriptionRequest,
//         onEstablished: () => mutationDebuggingPrint('Subscription established'),
//       )
//       // Listens to only 5 elements
//       .take(5)
//       .handleError(
//     (Object error) {
//       mutationDebuggingPrint('Error in subscription stream: $error');
//     },
//   );
//   return operation;
// }
//
// StreamSubscription<GraphQLResponse<Announcement>>? subscription;
//
// void unsubscribe() {
//   subscription?.cancel();
//   subscription = null;
// }
//
// void mutationDebuggingPrint(String shouldPrint) {
//   if (kDebugMode) {
//     print("##" * 100);
//     print(shouldPrint);
//     print("##" * 100);
//   }
// }
