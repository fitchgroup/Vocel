import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/features/announcement/data/post_repository.dart';
import 'package:vocel/models/Post.dart';

final postControllerProvider = Provider<PostController>((ref) {
  return PostController(ref);
});

class PostController {
  PostController(this.ref);

  final Ref ref;

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }

  Future<void> edit(Post updatedPost) async {
    final postsRepository = ref.read(postsRepositoryProvider);
    await postsRepository.update(updatedPost);
  }

  Future<void> delete(Post deletedPost) async {
    final postsRepository = ref.read(postsRepositoryProvider);
    await postsRepository.delete(deletedPost);
  }

  Future<void> editLikes(Post likedPost, String editPerson) async {
    final postsRepository = ref.read(postsRepositoryProvider);
    await postsRepository.likePost(likedPost, editPerson);
  }
}
