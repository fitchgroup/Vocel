import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/models/ModelProvider.dart';

StreamSubscription<GraphQLResponse<Announcement>>? subscriptionAnnouncement;
StreamSubscription<GraphQLResponse<CommentAnnouncement>>?
    subscriptionCommentAnnouncement;
StreamSubscription<GraphQLResponse<Post>>? subscriptionPost;
StreamSubscription<GraphQLResponse<Comment>>? subscriptionComment;
StreamSubscription<GraphQLResponse<VocelEvent>>? subscriptionVocelEvent;
StreamSubscription<GraphQLResponse<VocelMessage>>? subscriptionVocelMessage;

void subscribeAnnouncement() {
  final subscriptionRequest =
      ModelSubscriptions.onCreate(Announcement.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(Announcement.classType);
  final Stream<GraphQLResponse<Announcement>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        safePrint('subscriptionAnnouncement on create established'),
  );
  final Stream<GraphQLResponse<Announcement>> operation2 =
      Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        safePrint('subscriptionAnnouncement on delete established'),
  );
  subscriptionAnnouncement = operation.listen(
    (event) {
      safePrint('subscriptionAnnouncement event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionAnnouncement stream: $e'),
  );
  subscriptionAnnouncement = operation2.listen(
    (event) {
      safePrint('subscriptionAnnouncement event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionAnnouncement stream: $e'),
  );
}

void subscribeCommentAnnouncement() {
  final subscriptionRequest =
      ModelSubscriptions.onCreate(CommentAnnouncement.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(CommentAnnouncement.classType);
  final Stream<GraphQLResponse<CommentAnnouncement>> operation =
      Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        safePrint('subscriptionCommentAnnouncement on create established'),
  );
  final Stream<GraphQLResponse<CommentAnnouncement>> operation2 =
      Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        safePrint('subscriptionCommentAnnouncement on delete established'),
  );
  subscriptionCommentAnnouncement = operation.listen(
    (event) {
      safePrint(
          'subscriptionCommentAnnouncement event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionCommentAnnouncement stream: $e'),
  );
  subscriptionCommentAnnouncement = operation2.listen(
    (event) {
      safePrint(
          'subscriptionCommentAnnouncement event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionCommentAnnouncement stream: $e'),
  );
}

void subscribePost() {
  final subscriptionRequest = ModelSubscriptions.onCreate(Post.classType);
  final subscriptionRequest2 = ModelSubscriptions.onDelete(Post.classType);
  final Stream<GraphQLResponse<Post>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () => safePrint('subscriptionPost on create established'),
  );
  final Stream<GraphQLResponse<Post>> operation2 = Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () => safePrint('subscriptionPost on delete established'),
  );
  subscriptionPost = operation.listen(
    (event) {
      safePrint('subscriptionPost event data received: ${event.data}');
    },
    onError: (Object e) => safePrint('Error in subscriptionPost stream: $e'),
  );
  subscriptionPost = operation2.listen(
    (event) {
      safePrint('subscriptionPost event data received: ${event.data}');
    },
    onError: (Object e) => safePrint('Error in subscriptionPost stream: $e'),
  );
}

void subscribeComment() {
  final subscriptionRequest = ModelSubscriptions.onCreate(Comment.classType);
  final subscriptionRequest2 = ModelSubscriptions.onDelete(Comment.classType);
  final Stream<GraphQLResponse<Comment>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () => safePrint('subscriptionComment on create established'),
  );
  final Stream<GraphQLResponse<Comment>> operation2 = Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () => safePrint('subscriptionComment on delete established'),
  );
  subscriptionComment = operation.listen(
    (event) {
      safePrint('subscriptionComment event data received: ${event.data}');
    },
    onError: (Object e) => safePrint('Error in subscriptionComment stream: $e'),
  );
  subscriptionComment = operation2.listen(
    (event) {
      safePrint('subscriptionComment event data received: ${event.data}');
    },
    onError: (Object e) => safePrint('Error in subscriptionComment stream: $e'),
  );
}

void subscribeVocelEvent() {
  final subscriptionRequest = ModelSubscriptions.onCreate(VocelEvent.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(VocelEvent.classType);
  final Stream<GraphQLResponse<VocelEvent>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        safePrint('subscriptionVocelEvent on create established'),
  );
  final Stream<GraphQLResponse<VocelEvent>> operation2 = Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        safePrint('subscriptionVocelEvent on delete established'),
  );
  subscriptionVocelEvent = operation.listen(
    (event) {
      safePrint('subscriptionVocelEvent event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionVocelEvent stream: $e'),
  );
  subscriptionVocelEvent = operation2.listen(
    (event) {
      safePrint('subscriptionVocelEvent event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionVocelEvent stream: $e'),
  );
}

void subscribeVocelMessage() {
  final subscriptionRequest =
      ModelSubscriptions.onCreate(VocelMessage.classType);
  final subscriptionRequest2 =
      ModelSubscriptions.onDelete(VocelMessage.classType);
  final Stream<GraphQLResponse<VocelMessage>> operation = Amplify.API.subscribe(
    subscriptionRequest,
    onEstablished: () =>
        safePrint('subscriptionVocelMessage on create established'),
  );
  final Stream<GraphQLResponse<VocelMessage>> operation2 =
      Amplify.API.subscribe(
    subscriptionRequest2,
    onEstablished: () =>
        safePrint('subscriptionVocelMessage on delete established'),
  );
  subscriptionVocelMessage = operation.listen(
    (event) {
      safePrint('subscriptionVocelMessage event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionVocelMessage stream: $e'),
  );
  subscriptionVocelMessage = operation2.listen(
    (event) {
      safePrint('subscriptionVocelMessage event data received: ${event.data}');
    },
    onError: (Object e) =>
        safePrint('Error in subscriptionVocelMessage stream: $e'),
  );
}

void unsubscribe() {
  subscriptionAnnouncement?.cancel();
  subscriptionCommentAnnouncement?.cancel();
  subscriptionPost?.cancel();
  subscriptionComment?.cancel();
  subscriptionVocelEvent?.cancel();
  subscriptionVocelMessage?.cancel();
  subscriptionAnnouncement = null;
  subscriptionCommentAnnouncement = null;
  subscriptionPost = null;
  subscriptionComment = null;
  subscriptionVocelEvent = null;
  subscriptionVocelMessage = null;
}
