import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/services/post_datastore.dart';
import 'package:vocel/models/Post.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  PostsDataStoreService postsDataStoreService =
  ref.read(postsDataStoreServiceProvider);
  return PostsRepository(postsDataStoreService);
});

final postsListStreamProvider = StreamProvider.autoDispose<List<Post?>>((ref) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.getPosts();
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

class PostsRepository {
  PostsRepository(this.postsDataStoreService);

  final PostsDataStoreService postsDataStoreService;

  Stream<List<Post>> getPosts() {
    return postsDataStoreService.listenToPosts();
  }

  Stream<List<Post>> getPastPosts() {
    return postsDataStoreService.listenToPastPosts();
  }

  Future<void> add(Post event) async {
    await postsDataStoreService.addPost(event);
  }

  Future<void> update(Post updatedEvent) async {
    await postsDataStoreService.updatePost(updatedEvent);
  }

  Future<void> delete(Post deletedPost) async {
    await postsDataStoreService.deletePost(deletedPost);
  }

  Future<void> likePost(Post likedPost, String editPerson) async {
    await postsDataStoreService.editLikes(likedPost, editPerson);
  }

  Stream<Post> get(String id) {
    return postsDataStoreService.getPostStream(id);
  }
}
