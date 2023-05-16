import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/data/trip_repository.dart';

import 'package:vocel/features/announcement/ui/setting_page/setting_page.dart';

import 'package:vocel/features/announcement/ui/announcements_list/setting_page.dart';

import 'package:vocel/features/announcement/ui/calendar_page/calendar_util.dart';
import 'package:vocel/features/announcement/ui/calendar_page/trip_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_util.dart';

// from flutter doc: this file is purely for testing right now
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0




class CalendarListPage extends StatefulWidget {
  @override
  _CalendarListPageState createState() => _CalendarListPageState();
}

class _CalendarListPageState extends State<CalendarListPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, value, _) {
              return _CalendarHeader(
                focusedDay: value,
                clearButtonVisible: canClearSelection,
                onTodayButtonTap: () {
                  setState(() => _focusedDay.value = DateTime.now());
                },
                onClearButtonTap: () {
                  setState(() {
                    _rangeStart = null;
                    _rangeEnd = null;
                    _selectedDays.clear();
                    _selectedEvents.value = [];
                  });
                },
                onLeftArrowTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                onRightArrowTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
              );
            },
          ),
          TableCalendar<Event>(
            locale: Localizations.localeOf(context).toString(),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay.value,
            headerVisible: false,
            selectedDayPredicate: (day) => _selectedDays.contains(day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            // predict a holiday
            // holidayPredicate: (day) {
            //   return day.day == 20;
            // },
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            }
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${_calendarFormat}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 100.0,
            child: Text(
              headerText,
              style: const TextStyle(
                  fontSize: 23.0,
                  color: Color(constants.primaryDarkTeal)
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, size: 17.0, color: Color(constants.primaryDarkTeal),),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 17.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}


// class CalendarListPage extends  StatefulWidget{ // HookConsumerWidget {
//   const CalendarListPage({
//     super.key,
//   });
//
//   void showAddTripDialog(BuildContext context) async {
//     await showModalBottomSheet<void>(
//       isScrollControlled: true,
//       elevation: 5,
//       context: context,
//       builder: (BuildContext context) {
//         return Text("testing");
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     CalendarFormat _calendarFormat = CalendarFormat.month;
//     DateTime _focusedDay = DateTime.now();
//     DateTime? _selectedDay;
//     final Orientation orientation = MediaQuery.of(context).orientation;
//     final tripsListValue = ref.watch(tripsListStreamProvider);
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             showAddTripDialog(context);
//           },
//           backgroundColor: const Color(constants.primaryColorDark),
//           child: const Icon(Icons.add),
//         ),
//       body: TableCalendar(
//         firstDay: kFirstDay,
//         lastDay: kLastDay,
//         focusedDay: _focusedDay,
//         calendarFormat: _calendarFormat,
//         selectedDayPredicate: (day) {
//           // Use `selectedDayPredicate` to determine which day is currently selected.
//           // If this returns true, then `day` will be marked as selected.
//
//           // Using `isSameDay` is recommended to disregard
//           // the time-part of compared DateTime objects.
//           return isSameDay(_selectedDay, day);
//         },
//         onDaySelected: (selectedDay, focusedDay) {
//           if (!isSameDay(_selectedDay, selectedDay)) {
//             // Call `setState()` when updating the selected day
//             setState(() {
//               _selectedDay = selectedDay;
//               _focusedDay = focusedDay;
//             });
//           }
//         },
//         onFormatChanged: (format) {
//           if (_calendarFormat != format) {
//             // Call `setState()` when updating calendar format
//             setState(() {
//               _calendarFormat = format;
//             });
//           }
//         },
//         onPageChanged: (focusedDay) {
//           // No need to call `setState()` here
//           _focusedDay = focusedDay;
//         },
//       ),
//         // tripsListValue.when(
//         //     data: (trips) => trips.isEmpty
//         //         ? const Center(
//         //       child: Text('No Trips'),
//         //     )
//         //         : Column(
//         //       children: [
//         //         Flexible(
//         //           child: GridView.count(
//         //             crossAxisCount:
//         //             (orientation == Orientation.portrait) ? 2 : 3,
//         //             mainAxisSpacing: 4,
//         //             crossAxisSpacing: 4,
//         //             padding: const EdgeInsets.all(4),
//         //             childAspectRatio:
//         //             (orientation == Orientation.portrait) ? 0.9 : 1.4,
//         //             children: trips.map((tripData) {
//         //               return TripCard(trip: tripData!);
//         //             }).toList(),
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //     error: (e, st) => const Center(
//         //       child: Text('Error'),
//         //     ),
//         //     loading: () => const Center(
//         //       child: CircularProgressIndicator(),
//         //     ))
//     );
//   }
// }
