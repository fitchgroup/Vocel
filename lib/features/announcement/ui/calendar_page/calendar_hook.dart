import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/data/event_repository.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_list_page.dart';
import 'package:vocel/models/ModelProvider.dart';

class CalendarHook extends HookConsumerWidget {
  const CalendarHook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// TODO: CHANGE TO POST PROBABLY
    // final AsyncValue<List<Announcement?>> calendarAnnouncementElement =
    //     ref.watch(tripsListStreamProvider);
    final AsyncValue<List<VocelEvent?>> calendarEventElement =
    ref.watch(eventsListStreamProvider);

    return Scaffold(
        body:
        // calendarAnnouncementElement.when(
        //   data: (calendarItem) {
        //     return
        calendarEventElement.when(
          data: (eventItem) {
            return CalendarListPage(
              calendarItemAnnouncement:
              // calendarItem.whereType<Announcement>().toList(),
              const [],
              calendarItemEvent: eventItem.whereType<VocelEvent>().toList(),
              refFromHook: ref,
            );
          },
          loading: () =>
          const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, st) =>
          const Center(
            child: Text('Error Here'),
          ),
        )
      // },
      // error: (e, st) =>
      // const Center(
      //   child: Text('Error Here'),
      // ),
      // loading: () =>
      // const Center(
      //   child: CircularProgressIndicator(),
      // ),
      // ),
    );
  }
}
