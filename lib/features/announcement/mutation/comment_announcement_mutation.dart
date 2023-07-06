import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/models/ModelProvider.dart';

Future<void> createCommentAnnouncement(CommentAnnouncement comment) async {
  try {
    final request = ModelMutations.create(comment);
    final response = await Amplify.API.mutate(request: request).response;

    final createdCommentAnnouncement = response.data;
    if (createdCommentAnnouncement == null) {
      mutationDebuggingPrint('errors: ${response.errors}');
      return;
    }
    mutationDebuggingPrint(
        'Mutation result: ${createdCommentAnnouncement.toJson().toString()}');
  } on ApiException catch (e) {
    mutationDebuggingPrint('Mutation failed: $e');
  }
}

Future<void> deleteCommentAnnouncement(
    CommentAnnouncement commentDelete) async {
  final request = ModelMutations.delete(commentDelete);
  final response = await Amplify.API.mutate(request: request).response;
  mutationDebuggingPrint('Response: $response');
}

/// FETCH DATA

Future<CommentAnnouncement?> queryItem(
    CommentAnnouncement queriedCommentAnnouncement) async {
  try {
    final request = ModelQueries.get(
      CommentAnnouncement.classType,
      queriedCommentAnnouncement.modelIdentifier,
    );
    final response = await Amplify.API.query(request: request).response;
    final comment = response.data;
    if (comment == null) {
      safePrint('errors: ${response.errors}');
    }
    return comment;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}

/// LIST ITEM

Future<List<CommentAnnouncement?>> queryListItems() async {
  try {
    final request = ModelQueries.list(CommentAnnouncement.classType);
    final response = await Amplify.API.query(request: request).response;

    final comments = response.data?.items;
    if (comments == null) {
      safePrint('errors: ${response.errors}');
      return const [];
    }
    return comments;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return const [];
  }
}

const limit = 100;

Future<List<CommentAnnouncement?>> queryPaginatedListItems() async {
  final firstRequest = ModelQueries.list<CommentAnnouncement>(
      CommentAnnouncement.classType,
      limit: limit);
  final firstResult = await Amplify.API.query(request: firstRequest).response;
  final firstPageData = firstResult.data;

  // Indicates there are > 100 todos and you can get the request for the next set.
  if (firstPageData?.hasNextResult ?? false) {
    final secondRequest = firstPageData!.requestForNextResult;
    final secondResult =
        await Amplify.API.query(request: secondRequest!).response;
    return secondResult.data?.items ?? <CommentAnnouncement?>[];
  } else {
    return firstPageData?.items ?? <CommentAnnouncement?>[];
  }
}
