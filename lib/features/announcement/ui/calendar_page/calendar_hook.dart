import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_list_page.dart';
import 'package:vocel/models/ModelProvider.dart';

class CalendarHook extends HookConsumerWidget{
  const CalendarHook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    // TODO: get the announcement, events references
    // get the calendarElement by getting the announcement values
    final AsyncValue<List<Announcement?>> calendarElement = ref.watch(tripsListStreamProvider);

    return Scaffold(
        body: calendarElement.when(
            data: (calendarItem) =>
            calendarItem.isEmpty ?
            CalendarListPage(calendarItem: const [], refFromHook: ref)
                :
            CalendarListPage(calendarItem: calendarItem.whereType<Announcement>().toList(), refFromHook: ref),
            error: (e, st) => const Center(
              child: Text('Error Here'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            )
        )
    );
  }

}