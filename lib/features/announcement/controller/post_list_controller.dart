import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/post_repository.dart';
import 'package:vocel/features/announcement/mutation/comment_mutation.dart';
import 'package:vocel/features/announcement/mutation/post_mutation.dart';
import 'package:vocel/models/Comment.dart';
import 'package:vocel/models/Post.dart';

final postsListControllerProvider = Provider<PostsListController>((ref) {
  return PostsListController(ref);
});

class PostsListController {
  PostsListController(this.ref);

  final Ref ref;

  Future<void> add({
    required String postAuthor,
    required String postContent,
  }) async {
    Post post = Post(
      postAuthor: postAuthor,
      postContent: postContent,
    );

    final postsRepository = ref.read(postsRepositoryProvider);

    await postsRepository.add(post);
    await createPost(post);
  }

  Future<void> addComment(
      {required String commentAuthor,
      required String commentContent,
      required Post relatedPost}) async {
    Comment comment = Comment(
      commentAuthor: commentAuthor,
      commentContent: commentContent,
      content: relatedPost.id,
      post: relatedPost,
    );

    final postsRepository = ref.read(postsRepositoryProvider);

    await postsRepository.addComment(comment);
    await createComment(comment);
  }
}
