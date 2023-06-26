import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/models/Post.dart';

/// The code is an implementation of a EventsDataStoreService class, which serves
/// as a data access service for managing events using Amplify DataStore.

final postsDataStoreServiceProvider = Provider<PostsDataStoreService>((ref) {
  final service = PostsDataStoreService();
  return service;
});

class PostsDataStoreService {
  PostsDataStoreService();

  /// listenToEvents: This method listens to changes in the events stored in the
  /// DataStore and returns a stream of events. It applies a filter to only include
  /// events with a start time in the future.

  Stream<List<Post>> listenToPosts() {
    return Amplify.DataStore.observeQuery(
      Post.classType,
      sortBy: [Post.POSTAUTHOR.ascending()],
    ).map((event) => event.items.toList()).handleError(
      (error) {
        debugPrint('listenToPosts: A Stream error happened in listenToPosts');
      },
    );
  }

  /// listenToPastEvents: This method is similar to listenToEvents, but it returns
  /// a stream of events that have already occurred. It applies a filter to only include
  /// events with a start time in the past.

  Stream<List<Post>> listenToPastPosts() {
    return Amplify.DataStore.observeQuery(
      Post.classType,
      sortBy: [Post.POSTAUTHOR.ascending()],
    ).map((event) => event.items.toList()).handleError(
      (error) {
        debugPrint(
            'listenToPosts: A Stream error happened in listenToPastPosts');
      },
    );
  }

  /// getEventStream: This method returns a stream for a specific event with the given id.
  /// It uses the observeQuery method to observe changes to the event in the DataStore.

  Stream<Post> getPostStream(String id) {
    final postStream =
        Amplify.DataStore.observeQuery(Post.classType, where: Post.ID.eq(id))
            .map((event) => event.items.toList().single);

    return postStream;
  }

  /// addEvent: This method adds a new event to the DataStore by calling the save
  /// method of Amplify DataStore.

  Future<void> addPost(Post post) async {
    try {
      await Amplify.DataStore.save(post);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// deleteEvent: This method deletes an existing event from the DataStore by calling
  /// the delete method of Amplify DataStore.

  Future<void> deletePost(Post post) async {
    try {
      await Amplify.DataStore.delete(post);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  /// updateEvent: This method updates an existing event in the DataStore by querying
  /// for the event with the specified id, creating a new event object with the updated
  /// fields, and then saving the updated event to the DataStore.

  Future<void> updatePost(Post updatedPost) async {
    try {
      final postsWithId = await Amplify.DataStore.query(
        Post.classType,
        where: Post.ID.eq(updatedPost.id),
      );

      final oldPost = postsWithId.first;
      final newPost = oldPost.copyWith(
        postAuthor: updatedPost.postAuthor,
        postContent: updatedPost.postContent,
      );

      await Amplify.DataStore.save(newPost);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> editLikes(Post likedPost, String editPerson) async {
    try {
      final postsWithId = await Amplify.DataStore.query(
        Post.classType,
        where: Post.ID.eq(likedPost.id),
      );

      final oldPost = postsWithId.first;
      List<String> assign =
          oldPost.likes != null ? List<String>.from(oldPost.likes!) : [];

      if (oldPost.likes != null) {
        if (oldPost.likes!.contains(editPerson)) {
          assign.remove(editPerson);
        } else {
          assign.add(editPerson);
        }
      } else {
        assign = [editPerson];
      }

      final newPost = oldPost.copyWith(likes: assign);

      await Amplify.DataStore.save(newPost);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
