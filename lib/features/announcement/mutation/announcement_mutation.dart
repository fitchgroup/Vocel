import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/models/ModelProvider.dart';

Future<void> createAnnouncement(Announcement announcement) async {
  try {
    final request = ModelMutations.create(announcement);
    final response = await Amplify.API.mutate(request: request).response;

    final createdAnnouncement = response.data;
    if (createdAnnouncement == null) {
      mutationDebuggingPrint('errors: ${response.errors}');
      return;
    }
    mutationDebuggingPrint(
        'Mutation result: ${createdAnnouncement.toJson().toString()}');
  } on ApiException catch (e) {
    mutationDebuggingPrint('Mutation failed: $e');
  }
}

Future<void> deleteAnnouncement(Announcement announcementDelete) async {
  final request = ModelMutations.delete(announcementDelete);
  final response = await Amplify.API.mutate(request: request).response;
  final deletedAnnouncement = response.data;
  if (deletedAnnouncement == null) {
    mutationDebuggingPrint('errors: ${response.errors}');
    return;
  }
  mutationDebuggingPrint(
      'Mutation result: ${deletedAnnouncement.toJson().toString()}');
  safePrint('Response: $response');
}

/// FETCH DATA

Future<Announcement?> queryItem(Announcement queriedAnnouncement) async {
  try {
    final request = ModelQueries.get(
      Announcement.classType,
      queriedAnnouncement.modelIdentifier,
    );
    final response = await Amplify.API.query(request: request).response;
    final announcement = response.data;
    if (announcement == null) {
      safePrint('errors: ${response.errors}');
    }
    return announcement;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}

/// LIST ITEM

Future<List<Announcement?>> queryListItems() async {
  try {
    final request = ModelQueries.list(Announcement.classType);
    final response = await Amplify.API.query(request: request).response;

    final announcements = response.data?.items;
    if (announcements == null) {
      safePrint('errors: ${response.errors}');
      return const [];
    }
    return announcements;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return const [];
  }
}

const limit = 100;

Future<List<Announcement?>> queryPaginatedListItems() async {
  final firstRequest =
      ModelQueries.list<Announcement>(Announcement.classType, limit: limit);
  final firstResult = await Amplify.API.query(request: firstRequest).response;
  final firstPageData = firstResult.data;

  // Indicates there are > 100 todos and you can get the request for the next set.
  if (firstPageData?.hasNextResult ?? false) {
    final secondRequest = firstPageData!.requestForNextResult;
    final secondResult =
        await Amplify.API.query(request: secondRequest!).response;
    return secondResult.data?.items ?? <Announcement?>[];
  } else {
    return firstPageData?.items ?? <Announcement?>[];
  }
}
