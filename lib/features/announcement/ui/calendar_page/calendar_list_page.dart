import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/calendar_page/calendar_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_header.dart';
import 'package:vocel/models/Trip.dart';

// from flutter doc: this file is purely for testing right now
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0


class CalendarListPage extends StatefulWidget {
  final List<Trip> calendarItem;
  final WidgetRef refFromHook;
  const CalendarListPage({super.key, required this.calendarItem, required this.refFromHook});

  @override
  _CalendarListPageState createState() => _CalendarListPageState();
}

class _CalendarListPageState extends State<CalendarListPage> {
  late final ValueNotifier<List<Trip>> _selectedEvents;
  final ValueNotifier<DateTime> _currentDateTime = ValueNotifier(DateTime.now());  // get the current datetime
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  // controller to move page back and forward
  late PageController _pageController;

  // this specify the original display, currently display the calendar by months
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // When RangeSelectionMode.toggledOff is used, it means that the selection of a range of
  // cells is disabled. It indicates that the range selection feature is turned off, and the
  // user cannot select a range of cells by dragging across them.
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // range the selected dates
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  var calendarItem;



  @override
  void initState() {
    super.initState();
    super.initState();

    _selectedDays.add(_currentDateTime.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_currentDateTime.value));
  }

  @override
  void dispose() {
    _currentDateTime.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  late LinkedHashMap<DateTime, List<Trip>> calendarRenderMap = LinkedHashMap<DateTime, List<Trip>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(change());



  late LinkedHashMap<DateTime, List<Trip>> calendarRenderSource;

  LinkedHashMap<DateTime, List<Trip>> change() {
    calendarRenderSource = LinkedHashMap<DateTime, List<Trip>>(); // Initialize the variable with the correct type
    for (var item in widget.calendarItem) {
      final key = item.endDate.getDateTime();
      if (calendarRenderSource.containsKey(key)) {
        calendarRenderSource[key] = [
          ...calendarRenderSource[key]!,
          item,
        ];
      } else {
        calendarRenderSource[key] = [item];
      }
    }
    return calendarRenderSource;
  }





  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;  // decide whether the clearButton should be displayed

  List<Trip> _getEventsForDay(DateTime day) {
    return calendarRenderMap[day] ?? [];
  }

  List<Trip> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Trip> _getEventsForRange(DateTime start, DateTime end) {
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

      _currentDateTime.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _currentDateTime.value = focusedDay;
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
            valueListenable: _currentDateTime,
            builder: (context, value, _) {
              return CalendarHeader(
                focusedDay: value, // is the _currentDateTime
                clearButtonVisible: canClearSelection, // display unless _selectedDays and rangeStart and rangeEnd are all null/empty
                onTodayButtonTap: () {
                  setState(() => _currentDateTime.value = DateTime.now());
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
          TableCalendar<Trip>(
              locale: Localizations.localeOf(context).toString(),
              firstDay: utilFirstDay,
              lastDay: utilLateDay,
              focusedDay: _currentDateTime.value,
              headerVisible: false, // delete the default header
              selectedDayPredicate: (day) => _selectedDays.contains(day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat, // the default calendarFormat is set to display months
              rangeSelectionMode: _rangeSelectionMode,  // the default method to get the selected dates
              eventLoader: _getEventsForDay,  //
              // predict a holiday
              // holidayPredicate: (day) {
              //   return day.day == 20;
              // },
              onDaySelected: _onDaySelected,  // select the dates by clicking
              onRangeSelected: _onRangeSelected,
              onCalendarCreated: (controller) => _pageController = controller,
              onPageChanged: (focusedDay) => _currentDateTime.value = focusedDay,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              }
          ),
          const SizedBox(height: 8.0),
          // Text('${widget.calendarItem}'),
          Expanded(
            child: ValueListenableBuilder<List<Trip>>(
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
                        title: Text('${value[index]}'),
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

