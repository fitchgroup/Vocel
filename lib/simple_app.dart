import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedInputResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/LocalizedTitleResolver.dart';
import 'package:vocel/common/utils/language_constants.dart';
import 'package:vocel/common/utils/notification_util.dart';
import 'package:vocel/features/announcement/ui/drawer_list/bottom_navigation.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/models/VocelEvent.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale changedLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(changedLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _local;

  changeLocale(Locale currentLocale) {
    setState(() {
      _local = currentLocale;
    });
  }

  List<Announcement?> allAnnouncements = [];
  List<VocelEvent?> allVocelEvents = [];
  SubscriptionStatus prevSubscriptionStatus = SubscriptionStatus.disconnected;
  StreamSubscription<GraphQLResponse<Announcement>>? subscription;
  StreamSubscription<GraphQLResponse<VocelEvent>>? subscription2;

  @override
  void initState() {
    /// ...

// Init listeners
    Amplify.Hub.listen(
      HubChannel.Api,
      (ApiHubEvent event) {
        if (event is SubscriptionHubEvent) {
          if (prevSubscriptionStatus == SubscriptionStatus.connecting &&
              event.status == SubscriptionStatus.connected) {
            // getAnnouncements(); // refetch todos
            // getVocelEvents();
          }
          prevSubscriptionStatus = event.status;
        }
      },
    );
    unsubscribe();
    // subscribe();

    super.initState();
  }

  Future<void> getAnnouncements() async {
    try {
      final request = ModelQueries.list(Announcement.classType);
      final response = await Amplify.API.query(request: request).response;

      final todos = response.data?.items ?? [];
      if (response.errors.isNotEmpty) {
        testDebuggingPrint('errors: ${response.errors}');
      }

      setState(() {
        allAnnouncements = todos;
      });
    } on ApiException catch (e) {
      testDebuggingPrint('Query failed: $e');
      return;
    }
  }

  // Future<void> getVocelEvents() async {
  //   try {
  //     final request = ModelQueries.list(VocelEvent.classType);
  //     final response = await Amplify.API.query(request: request).response;
  //
  //     final todos = response.data?.items ?? [];
  //     if (response.errors.isNotEmpty) {
  //       testDebuggingPrint('errors: ${response.errors}');
  //     }
  //
  //     setState(() {
  //       allVocelEvents = todos;
  //     });
  //   } on ApiException catch (e) {
  //     testDebuggingPrint('Query failed: $e');
  //     return;
  //   }
  // }

  void subscribe() {
    /// GET THE ANNOUNCEMENT DATA
    final subscriptionRequest =
        ModelSubscriptions.onCreate(Announcement.classType);
    final Stream<GraphQLResponse<Announcement>> operation =
        Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => testDebuggingPrint('Subscription established'),
    );
    subscription = operation.listen(
      (event) {
        setState(() async {
          NotificationSpecificDateTime result = NotificationSpecificDateTime(
            specificDateTime:
                event.data!.createdAt!.getDateTimeInUtc().toLocal(),
            timeOfDay: TimeOfDay(
              hour: TimeOfDay.now().hour,
              minute: TimeOfDay.now().minute + 1,
            ),
          );
          allAnnouncements.add(event.data);
          safePrint("=" * 30 + allAnnouncements.length.toString() + "=" * 30);
          if (event.data != null) {
            scheduleSpecificVocelNotification(result, event.data!);
          }
        });
      },
      onError: (Object e) =>
          testDebuggingPrint('Error in subscription stream: $e'),
    );

    /// GET THE VOCELEVENT DATA
    // final subscriptionRequest2 =
    // ModelSubscriptions.onCreate(VocelEvent.classType);
    // final Stream<GraphQLResponse<VocelEvent>> operation2 =
    // Amplify.API.subscribe(
    //   subscriptionRequest2,
    //   onEstablished: () => testDebuggingPrint('Subscription established'),
    // );
    // subscription2 = operation2.listen(
    //       (event) {
    //     setState(() {
    //       allVocelEvents.add(event.data);
    //       testDebuggingPrint(allVocelEvents.length.toString());
    //     });
    //   },
    //   onError: (Object e) =>
    //       testDebuggingPrint('Error in subscription stream: $e'),
    // );
  }

  void unsubscribe() {
    subscription?.cancel();
    subscription = null;
  }

  void testDebuggingPrint(String shouldPrint) {
    if (kDebugMode) {
      print("^=^" * 100);
      print(shouldPrint);
      print("v=v" * 100);
    }
  }

  @override
  void didChangeDependencies() {
    // keep language when refresh, this should be needed
    // not sure why the app works without this
    /// BUG:
    /// Context of a state is available to us from the moment the State loads its dependencies.
    /// At the time build is called, context is available to us and is passed as an argument.
    /** initstate is called before the state loads its dependencies and for that reason no
        context is available and you get an error for that if you use context in initstate.
        However, didChangeDependencies is called just a few moments after the state loads its
        dependencies and context is available at this moment so here you can use context **/

    /** However both of them are called before build is called. The only difference is that
        one is called before the state loads its dependencies and the other is called a few
        moments after the state loads its dependencies. **/

    getLocale().then((locale) => setLocale(locale.languageCode));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const stringResolver = AuthStringResolver(
        buttons: LocalizedButtonResolver(),
        inputs: LocalizedInputResolver(),
        titles: LocalizedTitleResolver(),
        messages: LocalizedMessageResolver());

    return Authenticator(
      stringResolver: stringResolver,
      child: MaterialApp(
        // ignore: prefer_const_literals_to_create_immutables
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        locale: _local,
        builder: Authenticator.builder(),
        home: AnnouncementsListPage(),
      ),
    );
  }
}

// reference to change the language based on language on platform
// https://stackoverflow.com/questions/50923906/how-to-get-timezone-language-and-county-id-in-flutter-by-the-location-of-device
