import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/mutation/post_mutation.dart';
import 'package:vocel/features/announcement/services/post_datastore.dart';
import 'package:vocel/models/Comment.dart';
import 'package:vocel/models/Post.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  PostsDataStoreService postsDataStoreService =
      ref.read(postsDataStoreServiceProvider);
  return PostsRepository(postsDataStoreService);
});

/// TODO: using this methods, sync other models
final postsListStreamProvider =
    StreamProvider.autoDispose<List<Post?>>((ref) async* {
  final postsRepository = ref.watch(postsRepositoryProvider);

  List<Post?> serverPosts = await queryPostListItems();
  if (serverPosts.isNotEmpty) {
    for (var post in serverPosts) {
      await Amplify.DataStore.save(post!);
    }
  }

  yield* postsRepository.getPosts();
});

final pastPostsListStreamProvider =
    StreamProvider.autoDispose<List<Post?>>((ref) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.getPastPosts();
});

final postProvider =
    StreamProvider.autoDispose.family<Post?, String>((ref, id) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.get(id);
});

final commentsListStreamProvider =
    StreamProvider.autoDispose.family<List<Comment?>, Post>((ref, post) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.getComments(post);
});

final pastCommentsListStreamProvider =
    StreamProvider.autoDispose<List<Comment?>>((ref) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.getPastComments();
});

final commentProvider =
    StreamProvider.autoDispose.family<Comment?, String>((ref, id) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.get2(id);
});

class PostsRepository {
  PostsRepository(this.postsDataStoreService);

  final PostsDataStoreService postsDataStoreService;

  Stream<List<Post>> getPosts() {
    return postsDataStoreService.listenToPosts();
  }

  Stream<List<Post>> getPastPosts() {
    return postsDataStoreService.listenToPastPosts();
  }

  Stream<List<Comment>> getComments(Post thisPost) {
    return postsDataStoreService.listenToComments(thisPost);
  }

  Stream<List<Comment>> getPastComments() {
    return postsDataStoreService.listenToPastComments();
  }

  Future<void> add(Post event) async {
    await postsDataStoreService.addPost(event);
  }

  Future<void> addComment(Comment event) async {
    await postsDataStoreService.addComment(event);
  }

  Future<void> update(Post updatedEvent) async {
    await postsDataStoreService.updatePost(updatedEvent);
  }

  Future<void> delete(Post deletedPost) async {
    await postsDataStoreService.deletePost(deletedPost);
  }

  Future<void> deleteComment(Comment deletedComment) async {
    await postsDataStoreService.deleteComment(deletedComment);
  }

  Future<void> likePost(Post likedPost, String editPerson) async {
    await postsDataStoreService.editLikes(likedPost, editPerson);
  }

  Future<void> commentPost(Post commentedPost, String editPerson) async {
    await postsDataStoreService.editComments(commentedPost, editPerson);
  }

  Stream<Post> get(String id) {
    return postsDataStoreService.getPostStream(id);
  }

  Stream<Comment> get2(String id) {
    return postsDataStoreService.getCommentStream(id);
  }
}
