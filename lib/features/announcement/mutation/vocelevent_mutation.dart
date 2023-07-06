import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/models/ModelProvider.dart';

Future<void> createVocelEvent(VocelEvent event) async {
  try {
    final request = ModelMutations.create(event);
    final response = await Amplify.API.mutate(request: request).response;

    final createdVocelEvent = response.data;
    if (createdVocelEvent == null) {
      mutationDebuggingPrint('errors: ${response.errors}');
      return;
    }
    mutationDebuggingPrint(
        'Mutation result: ${createdVocelEvent.toJson().toString()}');
  } on ApiException catch (e) {
    mutationDebuggingPrint('Mutation failed: $e');
  }
}

Future<void> deleteVocelEvent(VocelEvent eventDelete) async {
  final request = ModelMutations.delete(eventDelete);
  final response = await Amplify.API.mutate(request: request).response;
  mutationDebuggingPrint('Response: $response');
}

/// FETCH DATA

Future<VocelEvent?> queryVocelEventItem(VocelEvent queriedVocelEvent) async {
  try {
    final request = ModelQueries.get(
      VocelEvent.classType,
      queriedVocelEvent.modelIdentifier,
    );
    final response = await Amplify.API.query(request: request).response;
    final event = response.data;
    if (event == null) {
      safePrint('errors: ${response.errors}');
    }
    return event;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}

/// LIST ITEM

Future<List<VocelEvent?>> queryVocelEventListItems() async {
  try {
    final request = ModelQueries.list(VocelEvent.classType);
    final response = await Amplify.API.query(request: request).response;

    final events = response.data?.items;
    if (events == null) {
      safePrint('errors: ${response.errors}');
      return const [];
    }
    return events;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return const [];
  }
}

const limit = 100;

Future<List<VocelEvent?>> queryPaginatedVocelEventListItems() async {
  final firstRequest =
      ModelQueries.list<VocelEvent>(VocelEvent.classType, limit: limit);
  final firstResult = await Amplify.API.query(request: firstRequest).response;
  final firstPageData = firstResult.data;

  // Indicates there are > 100 todos and you can get the request for the next set.
  if (firstPageData?.hasNextResult ?? false) {
    final secondRequest = firstPageData!.requestForNextResult;
    final secondResult =
        await Amplify.API.query(request: secondRequest!).response;
    return secondResult.data?.items ?? <VocelEvent?>[];
  } else {
    return firstPageData?.items ?? <VocelEvent?>[];
  }
}
