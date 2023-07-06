import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/models/ModelProvider.dart';

Future<void> createPost(Post post) async {
  try {
    final request = ModelMutations.create(post);
    final response = await Amplify.API.mutate(request: request).response;

    final createdPost = response.data;
    if (createdPost == null) {
      mutationDebuggingPrint('errors: ${response.errors}');
      return;
    }
    mutationDebuggingPrint(
        'Mutation result: ${createdPost.toJson().toString()}');
  } on ApiException catch (e) {
    mutationDebuggingPrint('Mutation failed: $e');
  }
}

Future<void> deletePost(Post postDelete) async {
  final request = ModelMutations.delete(postDelete);
  final response = await Amplify.API.mutate(request: request).response;
  mutationDebuggingPrint('Response: $response');
}

/// FETCH DATA

Future<Post?> queryItem(Post queriedPost) async {
  try {
    final request = ModelQueries.get(
      Post.classType,
      queriedPost.modelIdentifier,
    );
    final response = await Amplify.API.query(request: request).response;
    final post = response.data;
    if (post == null) {
      safePrint('errors: ${response.errors}');
    }
    return post;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}

/// LIST ITEM

Future<List<Post?>> queryListItems() async {
  try {
    final request = ModelQueries.list(Post.classType);
    final response = await Amplify.API.query(request: request).response;

    final posts = response.data?.items;
    if (posts == null) {
      safePrint('errors: ${response.errors}');
      return const [];
    }
    return posts;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return const [];
  }
}

const limit = 100;

Future<List<Post?>> queryPaginatedListItems() async {
  final firstRequest = ModelQueries.list<Post>(Post.classType, limit: limit);
  final firstResult = await Amplify.API.query(request: firstRequest).response;
  final firstPageData = firstResult.data;

  // Indicates there are > 100 todos and you can get the request for the next set.
  if (firstPageData?.hasNextResult ?? false) {
    final secondRequest = firstPageData!.requestForNextResult;
    final secondResult =
        await Amplify.API.query(request: secondRequest!).response;
    return secondResult.data?.items ?? <Post?>[];
  } else {
    return firstPageData?.items ?? <Post?>[];
  }
}
