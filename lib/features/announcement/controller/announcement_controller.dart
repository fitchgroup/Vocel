import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/services/storage_services.dart';
import 'package:vocel/data/trip_repository.dart';
import 'package:vocel/models/Trip.dart';

final tripControllerProvider = Provider<TripController>((ref) {
  return TripController(ref);
});

class TripController {
  TripController(this.ref);
  final Ref ref;

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }


  Future<void> edit(Trip updatedTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.update(updatedTrip);
  }

  Future<void> delete(Trip deletedTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.delete(deletedTrip);
  }

  Future<void> pinMe(Trip pinTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.pinMe(pinTrip);
  }

  Future<void> completeMe(Trip completeTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.completeMe(completeTrip);
  }
}
