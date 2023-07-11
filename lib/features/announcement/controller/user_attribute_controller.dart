import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/common/utils/manage_user.dart';

final userAttributeControllerProvider =
    Provider<UserAttributeController>((ref) {
  return UserAttributeController(ref);
});

class UserAttributeController {
  UserAttributeController(this.ref);

  final Ref ref;

  Future<void> uploadAvatarFile(File file) async {
    final fileKey = await ref.read(storageServiceProvider).uploadFile(file);
    if (fileKey != null) {
      final imageUrl =
          await ref.read(storageServiceProvider).getImageUrl(fileKey);

      addVocelUserAttribute(attrName: 'custom:avatarKey', attrValue: fileKey);
      addVocelUserAttribute(attrName: 'custom:avatarUrl', attrValue: imageUrl);
      ref.read(storageServiceProvider).resetUploadProgress();
    }
  }

  ValueNotifier<double> uploadAvatarProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }
}
