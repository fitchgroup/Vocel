import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/event_controller.dart';
import 'package:vocel/features/announcement/data/event_repository.dart';
import 'package:vocel/features/announcement/mutation/vocelevent_mutation.dart';
import 'package:vocel/features/announcement/ui/event_list/add_event_bottomsheet.dart';
import 'package:vocel/features/announcement/ui/event_list/event_card.dart';
import 'package:vocel/models/ProfileRole.dart';
import 'package:vocel/models/VocelEvent.dart';

class EventPage extends HookConsumerWidget {
  const EventPage({Key? key, required this.showEdit, required this.groupOfUser})
      : super(key: key);
  final bool showEdit;
  final groupOfUser;

  void showAddEventDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddEventBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    final AsyncValue<List<VocelEvent?>> reminderValue =
        ref.watch(eventsListStreamProvider);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: showEdit, // visibilityButton.value,
        child: FloatingActionButton(
          heroTag: "AnnouncementFloatingActionButton",
          backgroundColor: const Color(constants.primaryColorDark),
          onPressed: () async {
            showAddEventDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent, // Back Button Color
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white, // Back Icon Color
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          const LocalizedMessageResolver().eventDetail(context),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: reminderValue.when(
          data: (event) => event.isEmpty
              ? const Center(
                  child: Text("No Event"),
                )
              : buildEvents(
                  event
                      .whereType<VocelEvent>()
                      .where((thisEvent) => groupOfUser
                                  .toString()
                                  .split("version1")[0]
                                  .toUpperCase() ==
                              ProfileRole.STAFF.name
                          ? true
                          : (thisEvent.eventGroup.name ==
                                  groupOfUser
                                      .toString()
                                      .split("version1")[0]
                                      .toUpperCase() ||
                              thisEvent.eventGroup.name ==
                                  ProfileRole.STAFF.name ||
                              thisEvent.eventGroup.name ==
                                  ProfileRole.ALL.name))
                      .toList(),
                  ref),
          error: (e, st) => const Center(
                child: Text('Error Here'),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }

  Center buildEvents(List<VocelEvent> events, WidgetRef ref) {
    events.sort((a, b) {
      if (a.startTime.compareTo(b.startTime) == 0) {
        return a.eventTitle.compareTo(b.eventTitle);
      }
      return -1 * (a.startTime.compareTo(b.startTime));
    });
    return Center(
      child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Dismissible(
              key: Key(event.id),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Show confirmation dialog for delete action
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Event"),
                        content: const Text(
                            "Are you sure you want to delete this event?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(
                                  false); // Dismiss the dialog and don't delete
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () {
                              ref.read(eventControllerProvider).delete(event);
                              deleteVocelEvent(event);
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog and delete
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              background: Container(
                color: Colors.blueGrey[600]?.withOpacity(0.4),
                // Customize the background color for complete action
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red[800]?.withOpacity(0.6),
                // Customize the background color for delete action
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: showEdit
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              child: Column(
                children: [
                  EventCard(event: event),
                ],
              ),
            );
          }),
    );
  }
}
