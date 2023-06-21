import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:vocel/features/announcement/ui/calendar_page/calendar_header.dart';
import 'package:vocel/models/Announcement.dart';
import 'package:vocel/models/VocelEvent.dart';

// from flutter doc: this file is purely for testing right now
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

class CalendarListPage extends StatefulWidget {
  // calendarItemAnnouncement stores the list of Announcements
  final List<Announcement> calendarItemAnnouncement;

  // calendarEvent stores the list of Events
  final List<VocelEvent> calendarItemEvent;
  final WidgetRef refFromHook;

  const CalendarListPage({super.key,
    required this.calendarItemAnnouncement,
    required this.calendarItemEvent,
    required this.refFromHook});

  @override
  _CalendarListPageState createState() => _CalendarListPageState();
}

class _CalendarListPageState extends State<CalendarListPage> {
  late final ValueNotifier<List<Announcement>> _selectedAnnouncements;
  late final ValueNotifier<List<VocelEvent>> _selectedEvents;
  final ValueNotifier<DateTime> _currentDateTime =
  ValueNotifier(DateTime.now()); // get the current datetime
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  // controller to move page back and forward
  late PageController _pageController;

  // this specify the original display, currently display the calendar by months ();
  // can choose to weeks, two weeks, it would change the display
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // When RangeSelectionMode.toggledOff is used, it means that the selection of a range of
  // cells is disabled. It indicates that the range selection feature is turned off, and the
  // user cannot select a range of cells by dragging across them.
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // range the selected dates
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDays.add(_currentDateTime.value);
    _selectedAnnouncements =
        ValueNotifier(_getAnnouncementsForDay(_currentDateTime.value));
    _selectedEvents = ValueNotifier(_getEventsForDay(_currentDateTime.value));
  }

  @override
  void dispose() {
    _currentDateTime.dispose();
    _selectedAnnouncements.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  // see if there are any selected days in the calendar, if yes, then the clear button shows; if not, there the clear button is hidden
  bool get canClearSelection =>
      _selectedDays.isNotEmpty ||
          _rangeStart != null ||
          _rangeEnd !=
              null; // decide whether the clearButton should be displayed

  /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
  late LinkedHashMap<DateTime, List<Announcement>> calendarRenderMap =
  LinkedHashMap<DateTime, List<Announcement>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )
    ..addAll(change());

  late LinkedHashMap<DateTime, List<VocelEvent>> calendarRenderMap2 =
  LinkedHashMap<DateTime, List<VocelEvent>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )
    ..addAll(change2());

  // this is to create a calendarRenderSource which is a LinkedHashMap<DateTime, List<Announcement>>,
  // and a calendarRenderSource2 which is a LinkedHashMap<DateTime, List<VocelEvent>>

  /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
  late LinkedHashMap<DateTime, List<Announcement>> calendarRenderSource;
  late LinkedHashMap<DateTime, List<VocelEvent>> calendarRenderSource2;

  LinkedHashMap<DateTime, List<Announcement>> change() {
    calendarRenderSource = LinkedHashMap<DateTime,
        List<Announcement>>(); // Initialize the variable with the correct type
    for (var item in widget.calendarItemAnnouncement) {
      final key = item.createdAt!.getDateTimeInUtc();
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

  LinkedHashMap<DateTime, List<VocelEvent>> change2() {
    calendarRenderSource2 = LinkedHashMap<DateTime,
        List<VocelEvent>>(); // Initialize the variable with the correct type
    for (var item in widget.calendarItemEvent) {
      DateTime dateOnly = DateTime(
          item.startTime
              .getDateTimeInUtc()
              .year,
          item.startTime
              .getDateTimeInUtc()
              .month,
          item.startTime
              .getDateTimeInUtc()
              .day);
      final key = dateOnly;
      if (calendarRenderSource2.containsKey(key)) {
        calendarRenderSource2[key] = [
          ...calendarRenderSource2[key]!,
          item,
        ];
      } else {
        calendarRenderSource2[key] = [item];
      }
    }
    debuggingPrint(calendarRenderSource2.toString());
    return calendarRenderSource2;
  }

  // ----------------------- here are the methods get respond from the maps ----------------------
  // ---------------------------------------------------------------------------------------------
  /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
  List<Announcement> _getAnnouncementsForDay(DateTime day) {
    return calendarRenderMap[day] ?? [];
  }

  List<VocelEvent> _getEventsForDay(DateTime day) {
    return calendarRenderMap2[day] ?? [];
  }

  /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
  List<Announcement> _getAnnouncementsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getAnnouncementsForDay(d),
    ];
  }

  List<VocelEvent> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  // get announcements within specific range
  /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
  List<Announcement> _getAnnoucementsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getAnnouncementsForDays(days);
  }

  // not used
  List<VocelEvent> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  // ---------------------------------------------------------------------------------------------

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

    /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
    //_selectedAnnouncements.value = _getAnnouncementsForDays(_selectedDays);
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

    /// TODO: CHANGE THE ANNOUNCEMENT TO POST?
    if (start != null && end != null) {
      // _selectedAnnouncements.value = _getAnnoucementsForRange(start, end);
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      // _selectedAnnouncements.value = _getAnnouncementsForDay(start);
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      // _selectedAnnouncements.value = _getAnnouncementsForDay(end);
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
                focusedDay: value,
                // is the _currentDateTime
                clearButtonVisible: canClearSelection,
                // display unless _selectedDays and rangeStart and rangeEnd are all null/empty
                onTodayButtonTap: () {
                  setState(() => _currentDateTime.value = DateTime.now());
                },
                onClearButtonTap: () {
                  setState(() {
                    _rangeStart = null;
                    _rangeEnd = null;
                    _selectedDays.clear();
                    _selectedAnnouncements.value = [];
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
          TableCalendar(
              locale: Localizations.localeOf(context).toString(),
              firstDay: utilFirstDay,
              lastDay: utilLateDay,
              focusedDay: _currentDateTime.value,
              headerVisible: false,
              // delete the default header
              selectedDayPredicate: (day) => _selectedDays.contains(day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              // the default calendarFormat is set to display months
              rangeSelectionMode: _rangeSelectionMode,
              // the default method to get the selected dates
              eventLoader: (day) {
                // final announcements = _getAnnouncementsForDay(day);
                final events = _getEventsForDay(day);
                // debuggingPrint(announcements.toString());
                // debuggingPrint(events.toString());
                return [
                  // ...announcements,
                  ...events
                ];
              },
              // predict a holiday
              // holidayPredicate: (day) {
              //   return day.day == 20;
              // },
              onDaySelected: _onDaySelected,
              // select the dates by clicking
              onRangeSelected: _onRangeSelected,
              onCalendarCreated: (controller) => _pageController = controller,
              onPageChanged: (focusedDay) =>
              _currentDateTime.value = focusedDay,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              }),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Announcement>>(
              valueListenable: _selectedAnnouncements,
              builder: (context, announcements, _) {
                return ValueListenableBuilder<List<VocelEvent>>(
                  valueListenable: _selectedEvents,
                  builder: (context, events, _) {
                    // Combine announcements and events into a single list
                    final combinedList = [...announcements, ...events];

                    return ListView.builder(
                      itemCount: combinedList.length,
                      itemBuilder: (context, index) {
                        final item = combinedList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color:
                                    Color(constants.shiftColor[index % 4]),
                                    width: 4.0)),
                            color: Colors.grey[
                            200], // Add a background color to mimic blockquote style
                          ),
                          padding: const EdgeInsets.all(8.0),
                          // Add some padding to the container
                          child: ListTile(
                            title: Text(
                              '$item',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  // Make the text italic
                                  color: Colors.grey[800],
                                  // Adjust text color to your preference
                                  fontFamily: "Pangolin",
                                  fontSize: 16),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // Align button to the center horizontally
                              children: [
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      VocelEvent thisEvent = item as VocelEvent;
                                      addingVocelEventToCalendar(thisEvent);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      // Remove the default padding inside the button
                                      backgroundColor: const Color(
                                          constants.primaryDarkTeal),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.event,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Add to Calendar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            fontFamily:
                                            'Montserrat', // Custom font family
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  void addingVocelEventToCalendar(VocelEvent thisEvent) {
    Event event = Event(
      title: thisEvent.eventTitle,
      description: thisEvent.eventDescription,
      location: thisEvent.eventLocation,
      startDate: thisEvent.startTime.getDateTimeInUtc().toLocal(),
      timeZone: DateTime
          .now()
          .timeZoneName,
      endDate: thisEvent.startTime
          .getDateTimeInUtc()
          .toLocal()
          .add(Duration(minutes: thisEvent.duration)),
      // iosParams: const IOSParams(
      //   reminder: Duration(/* Ex. hours:1 */),
      //   // on iOS, you can set alarm notification after your event.
      //   url:
      //       'https://www.example.com', // on iOS, you can set url to your event.
      // ),
      // androidParams: const AndroidParams(
      //   emailInvites: [], // on Android, you can add invite emails to your event.
      // ),
    );
    Add2Calendar.addEvent2Cal(event);
  }
}
