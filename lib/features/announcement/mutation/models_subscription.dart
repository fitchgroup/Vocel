import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/common/utils/notification_util.dart';
import 'package:vocel/features/announcement/services/announcement_datastore.dart';
import 'package:vocel/features/announcement/services/event_datastore.dart';
import 'package:vocel/features/announcement/services/message_datastore.dart';
import 'package:vocel/features/announcement/services/post_datastore.dart';
import 'package:vocel/models/ModelProvider.dart';

StreamSubscription<GraphQLResponse<Announcement>>? subscriptionAnnouncement;
// StreamSubscription<GraphQLResponse<CommentAnnouncement>>?
//     subscriptionCommentAnnouncement;
StreamSubscription<GraphQLResponse<Post>>? subscriptionPost;
// StreamSubscription<GraphQLResponse<Comment>>? subscriptionComment;
StreamSubscription<GraphQLResponse<VocelEvent>>? subscriptionVocelEvent;
StreamSubscription<GraphQLResponse<VocelMessage>>? subscriptionVocelMessage;

void subscribeAnnouncement() {
  TripsDataStoreService announcementDataStoreService = TripsDataStoreService();
  final subscriptionRequest =
      ModelSubscriptions.onCreate(Announcement.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(Announcement.classType);
  final Stream<GraphQLResponse<Announcement>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () => mutationDebuggingPrint(
        'subscriptionAnnouncement on create established'),
  );
  final Stream<GraphQLResponse<Announcement>> operation2 =
      Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () => mutationDebuggingPrint(
        'subscriptionAnnouncement on delete established'),
  );
  subscriptionAnnouncement = operation.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionAnnouncement event data received: ${event.data}');
      try {
        if (event.data != null) {
          await announcementDataStoreService.addAnnouncements(event.data!);
          NotificationSpecificDateTime result = NotificationSpecificDateTime(
            specificDateTime:
                event.data!.createdAt!.getDateTimeInUtc().toLocal(),
            timeOfDay: TimeOfDay(
              hour: TimeOfDay.now().hour,
              minute: TimeOfDay.now().minute + 1,
            ),
          );
          scheduleSpecificVocelAnnoucementNotification(result, event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while adding announcement: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionAnnouncement stream: $e'),
  );
  subscriptionAnnouncement = operation2.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionAnnouncement event data received: ${event.data}');
      try {
        if (event.data != null) {
          await announcementDataStoreService.deleteAnnouncements(event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while deleting announcement: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionAnnouncement stream: $e'),
  );
}

// void subscribeCommentAnnouncement() {
//   TripsDataStoreService commentAnnouncementDataStoreService =
//       TripsDataStoreService();
//   final subscriptionRequest =
//       ModelSubscriptions.onCreate(CommentAnnouncement.classType);
//   final subscriptionRequest2 =
//       ModelSubscriptions.onDelete(CommentAnnouncement.classType);
//   final Stream<GraphQLResponse<CommentAnnouncement>> operation =
//       Amplify.API.subscribe(
//     subscriptionRequest,
//     onEstablished: () => mutationDebuggingPrint(
//         'subscriptionCommentAnnouncement on create established'),
//   );
//   final Stream<GraphQLResponse<CommentAnnouncement>> operation2 =
//       Amplify.API.subscribe(
//     subscriptionRequest2,
//     onEstablished: () => mutationDebuggingPrint(
//         'subscriptionCommentAnnouncement on delete established'),
//   );
//   subscriptionCommentAnnouncement = operation.listen(
//     (event) async {
//       mutationDebuggingPrint(
//           'subscriptionCommentAnnouncement event data received: ${event.data}');
//       try {
//         if (event.data != null) {
//           await commentAnnouncementDataStoreService.addComment(event.data!);
//         }
//       } catch (e) {
//         mutationDebuggingPrint('Error while adding comment announcement: $e');
//       }
//     },
//     onError: (Object e) => mutationDebuggingPrint(
//         'Error in subscriptionCommentAnnouncement stream: $e'),
//   );
//   subscriptionCommentAnnouncement = operation2.listen(
//     (event) async {
//       mutationDebuggingPrint(
//           'subscriptionCommentAnnouncement event data received: ${event.data}');
//       try {
//         if (event.data != null) {
//           await commentAnnouncementDataStoreService.deleteComment(event.data!);
//         }
//       } catch (e) {
//         mutationDebuggingPrint('Error while deleting comment announcement: $e');
//       }
//     },
//     onError: (Object e) => mutationDebuggingPrint(
//         'Error in subscriptionCommentAnnouncement stream: $e'),
//   );
// }

void subscribePost() {
  PostsDataStoreService postsDataStoreService = PostsDataStoreService();
  final subscriptionRequest = ModelSubscriptions.onCreate(Post.classType);
  final subscriptionRequest2 = ModelSubscriptions.onDelete(Post.classType);
  final Stream<GraphQLResponse<Post>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        mutationDebuggingPrint('subscriptionPost on create established'),
  );
  final Stream<GraphQLResponse<Post>> operation2 = Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        mutationDebuggingPrint('subscriptionPost on delete established'),
  );
  subscriptionPost = operation.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionPost event data received: ${event.data}');
      try {
        if (event.data != null) {
          await postsDataStoreService.addPost(event.data!);
          NotificationSpecificDateTime result = NotificationSpecificDateTime(
            specificDateTime:
                event.data!.createdAt!.getDateTimeInUtc().toLocal(),
            timeOfDay: TimeOfDay(
              hour: TimeOfDay.now().hour,
              minute: TimeOfDay.now().minute + 1,
            ),
          );
          if ((event.data!).postGroup.name == ProfileRole.STAFF.name ||
              (event.data!).postGroup.name == ProfileRole.ALL.name) {
            scheduleSpecificVocelPostNotification(result, event.data!);
          }
        }
      } catch (e) {
        mutationDebuggingPrint('Error while adding post: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionPost stream: $e'),
  );
  subscriptionPost = operation2.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionPost event data received: ${event.data}');
      try {
        if (event.data != null) {
          await postsDataStoreService.deletePost(event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while deleting post: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionPost stream: $e'),
  );
}

// void subscribeComment() {
//   PostsDataStoreService commentDataStoreService = PostsDataStoreService();
//   final subscriptionRequest = ModelSubscriptions.onCreate(Comment.classType);
//   final subscriptionRequest2 = ModelSubscriptions.onDelete(Comment.classType);
//   final Stream<GraphQLResponse<Comment>> operation = Amplify.API.subscribe(
//     subscriptionRequest,
//     onEstablished: () =>
//         mutationDebuggingPrint('subscriptionComment on create established'),
//   );
//   final Stream<GraphQLResponse<Comment>> operation2 = Amplify.API.subscribe(
//     subscriptionRequest2,
//     onEstablished: () =>
//         mutationDebuggingPrint('subscriptionComment on delete established'),
//   );
//   subscriptionComment = operation.listen(
//     (event) async {
//       mutationDebuggingPrint(
//           'subscriptionComment event data received: ${event.data}');
//       try {
//         if (event.data != null) {
//           await commentDataStoreService.addComment(event.data!);
//         }
//       } catch (e) {
//         mutationDebuggingPrint('Error while adding comment: $e');
//       }
//     },
//     onError: (Object e) =>
//         mutationDebuggingPrint('Error in subscriptionComment stream: $e'),
//   );
//   subscriptionComment = operation2.listen(
//     (event) async {
//       mutationDebuggingPrint(
//           'subscriptionComment event data received: ${event.data}');
//       try {
//         if (event.data != null) {
//           await commentDataStoreService.deleteComment(event.data!);
//         }
//       } catch (e) {
//         mutationDebuggingPrint('Error while deleting comment: $e');
//       }
//     },
//     onError: (Object e) =>
//         mutationDebuggingPrint('Error in subscriptionComment stream: $e'),
//   );
// }

void subscribeVocelEvent() {
  EventsDataStoreService vocelEventDataStoreService = EventsDataStoreService();
  final subscriptionRequest = ModelSubscriptions.onCreate(VocelEvent.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(VocelEvent.classType);
  final Stream<GraphQLResponse<VocelEvent>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        mutationDebuggingPrint('subscriptionVocelEvent on create established'),
  );
  final Stream<GraphQLResponse<VocelEvent>> operation2 = Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        mutationDebuggingPrint('subscriptionVocelEvent on delete established'),
  );
  subscriptionVocelEvent = operation.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionVocelEvent event data received: ${event.data}');
      try {
        if (event.data != null) {
          await vocelEventDataStoreService.addEvent(event.data!);
          NotificationSpecificDateTime result = NotificationSpecificDateTime(
            specificDateTime:
                event.data!.createdAt!.getDateTimeInUtc().toLocal(),
            timeOfDay: TimeOfDay(
              hour: TimeOfDay.now().hour,
              minute: TimeOfDay.now().minute + 1,
            ),
          );
          scheduleSpecificVocelEventNotification(result, event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while adding vocel event: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionVocelEvent stream: $e'),
  );
  subscriptionVocelEvent = operation2.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionVocelEvent event data received: ${event.data}');
      try {
        if (event.data != null) {
          await vocelEventDataStoreService.deleteEvent(event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while deleting vocel event: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionVocelEvent stream: $e'),
  );
}

void subscribeVocelMessage(String? userEmail) {
  MessagesDataStoreService vocelMessageDataStoreService =
      MessagesDataStoreService();
  final subscriptionRequest =
      ModelSubscriptions.onCreate(VocelMessage.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(VocelMessage.classType);
  final Stream<GraphQLResponse<VocelMessage>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () => mutationDebuggingPrint(
        'subscriptionVocelMessage on create established'),
  );
  final Stream<GraphQLResponse<VocelMessage>> operation2 =
      Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () => mutationDebuggingPrint(
        'subscriptionVocelMessage on delete established'),
  );
  subscriptionVocelMessage = operation.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionVocelMessage event data received: ${event.data}, now the email is: $userEmail');
      try {
        if (event.data != null) {
          await vocelMessageDataStoreService.addMessage(event.data!);
          if (userEmail == null) {
            Map<String, String> stringMap = await getUserAttributes();
            userEmail = stringMap["email"];
          }
          if (event.data!.receiver == userEmail) {
            NotificationSpecificDateTime result = NotificationSpecificDateTime(
              specificDateTime:
                  event.data!.createdAt!.getDateTimeInUtc().toLocal(),
              timeOfDay: TimeOfDay(
                hour: TimeOfDay.now().hour,
                minute: TimeOfDay.now().minute,
              ),
            );
            scheduleSpecificMessageNotification(result, event.data!);
          }
        }
      } catch (e) {
        mutationDebuggingPrint('Error while adding vocel message: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionVocelMessage stream: $e'),
  );
  subscriptionVocelMessage = operation2.listen(
    (event) async {
      mutationDebuggingPrint(
          'subscriptionVocelMessage event data received: ${event.data}');
      try {
        if (event.data != null) {
          await vocelMessageDataStoreService.deleteMessage(event.data!);
        }
      } catch (e) {
        mutationDebuggingPrint('Error while deleting vocel message: $e');
      }
    },
    onError: (Object e) =>
        mutationDebuggingPrint('Error in subscriptionVocelMessage stream: $e'),
  );
}

// Future<void> subscribeModel() async {
//   subscribeAnnouncement();
//   subscribeCommentAnnouncement();
//   subscribePost();
//   subscribeComment();
//   subscribeVocelEvent();
//   subscribeVocelMessage();
//   if (kDebugMode) {
//     print("@" * 100 + '\n' + "Subscribe success\n" + "@" * 100);
//   }
// }
//
// Future<void> unsubscribeModel() async {
//   subscriptionAnnouncement?.cancel();
//   subscriptionCommentAnnouncement?.cancel();
//   subscriptionPost?.cancel();
//   subscriptionComment?.cancel();
//   subscriptionVocelEvent?.cancel();
//   subscriptionVocelMessage?.cancel();
//   subscriptionAnnouncement = null;
//   subscriptionCommentAnnouncement = null;
//   subscriptionPost = null;
//   subscriptionComment = null;
//   subscriptionVocelEvent = null;
//   subscriptionVocelMessage = null;
// }
