import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/common/utils/mutation_util.dart';
import 'package:vocel/models/ModelProvider.dart';

Future<void> createVocelMessage(VocelMessage vocelMessage) async {
  try {
    final request = ModelMutations.create(vocelMessage);
    final response = await Amplify.API.mutate(request: request).response;

    final createdVocelMessage = response.data;
    if (createdVocelMessage == null) {
      mutationDebuggingPrint('errors: ${response.errors}');
      return;
    }
    mutationDebuggingPrint(
        'Mutation result: ${createdVocelMessage.toJson().toString()}');
  } on ApiException catch (e) {
    mutationDebuggingPrint('Mutation failed: $e');
  }
}

Future<void> deleteVocelMessage(VocelMessage vocelMessageDelete) async {
  final request = ModelMutations.delete(vocelMessageDelete);
  final response = await Amplify.API.mutate(request: request).response;
  mutationDebuggingPrint('Response: $response');
}

/// FETCH DATA

Future<VocelMessage?> queryVocelMessageItem(
    VocelMessage queriedVocelMessage) async {
  try {
    final request = ModelQueries.get(
      VocelMessage.classType,
      queriedVocelMessage.modelIdentifier,
    );
    final response = await Amplify.API.query(request: request).response;
    final vocelMessage = response.data;
    if (vocelMessage == null) {
      safePrint('errors: ${response.errors}');
    }
    return vocelMessage;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}

/// LIST ITEM

Future<List<VocelMessage?>> queryVocelMessageListItems() async {
  try {
    Map<String, String> stringMap = await getUserAttributes();
    String? userEmail = stringMap["email"];

    final senderRequest = ModelQueries.list(VocelMessage.classType,
        where: VocelMessage.SENDER.eq(userEmail));
    final senderResponse =
        await Amplify.API.query(request: senderRequest).response;
    final senderMessages = senderResponse.data?.items;

    final receiverRequest = ModelQueries.list(VocelMessage.classType,
        where: VocelMessage.RECEIVER.eq(userEmail));
    final receiverResponse =
        await Amplify.API.query(request: receiverRequest).response;
    final receiverMessages = receiverResponse.data?.items;

    if (senderMessages == null || receiverMessages == null) {
      safePrint('errors: ${senderResponse.errors}, ${receiverResponse.errors}');
      return const [];
    }

    List<VocelMessage?> vocelMessages = [];
    vocelMessages.addAll(senderMessages);
    vocelMessages.addAll(receiverMessages);

    mutationDebuggingPrint(vocelMessages.length.toString());

    return vocelMessages;
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return const [];
  }
}

const limit = 100;

Future<List<VocelMessage?>> queryPaginatedVocelMessageListItems(
    {String? userEmail}) async {
  QueryPredicate predicate;
  if (userEmail != null) {
    predicate =
        VocelMessage.SENDER.eq(userEmail) | VocelMessage.RECEIVER.eq(userEmail);
  } else {
    predicate = QueryPredicate.all;
  }
  final firstRequest = ModelQueries.list<VocelMessage>(VocelMessage.classType,
      limit: limit, where: predicate);
  final firstResult = await Amplify.API.query(request: firstRequest).response;
  final firstPageData = firstResult.data;

  // Indicates there are > 100 todos and you can get the request for the next set.
  if (firstPageData?.hasNextResult ?? false) {
    final secondRequest = firstPageData!.requestForNextResult;
    final secondResult =
        await Amplify.API.query(request: secondRequest!).response;
    return secondResult.data?.items ?? <VocelMessage?>[];
  } else {
    return firstPageData?.items ?? <VocelMessage?>[];
  }
}
