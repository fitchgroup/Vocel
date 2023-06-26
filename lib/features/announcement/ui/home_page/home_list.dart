import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/controller/announcement_controller.dart';
import 'package:vocel/features/announcement/data/announcement_repository.dart';
import 'package:vocel/features/announcement/ui/home_page/add_announcement_bottomsheet.dart';
import 'package:vocel/features/announcement/ui/home_page/announcement_card.dart';
import 'package:vocel/features/announcement/ui/home_page/home_navigation_bar.dart';
import 'package:vocel/models/Announcement.dart';

class HomeAnnouncementFeed extends HookConsumerWidget {
  const HomeAnnouncementFeed(
      {Key? key, required this.showEdit, required this.onClickController})
      : super(key: key);

  final bool showEdit;
  final ValueChanged<String> onClickController;

  void showAddAnnouncementDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddTripBottomSheet();
      },
    );
  }

  /// uncomment this to enable visibilityButton
  // Future<bool> calculateFinalTesting() async {
  //   return await verifyAdminAccess();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// TODO: MAY UPDATE THIS TO CHANGE VISIBILITY SETTINGS
    // final visibilityButton = useState(false);

    /// why using [key] in the useEffect method.
    // The [key] in the useEffect hook's dependency list specifies that
    // the effect should be triggered whenever the key property changes.
    // It allows you to recalculate or update the visibility based on the
    // new value of key. If you don't need to track changes in the key property,
    // you can omit it from the dependency list to ensure the effect runs only
    // once during the widget's initial build.

    // useEffect(() {
    //   calculateFinalTesting().then((newVisibility) {
    //     if (newVisibility != visibilityButton.value) {
    //       visibilityButton.value = newVisibility;
    //     }
    //   });
    // }, [key]);

    final Orientation orientation = MediaQuery.of(context).orientation;
    final AsyncValue<List<Announcement?>> reminderValue =
        ref.watch(tripsListStreamProvider);

    /// if use checkValidFuture
    // floatingActionButton: FutureBuilder<bool>(
    //   future: checkValid(keyString),
    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // While the future is still loading, you can show a progress indicator or any placeholder widget.
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // If an error occurred during the future execution, you can handle it accordingly.
    //       return Text('Error: ${snapshot.error}');
    //     } else {
    //       final bool shouldShowFloatingActionButton = snapshot.data ?? false;
    //
    //       return Visibility(
    //         visible: shouldShowFloatingActionButton,
    //         child: FloatingActionButton(
    //           backgroundColor: const Color(constants.primaryColorDark),
    //           onPressed: () async {
    //             showAddAnnouncementDialog(context);
    //           },
    //           child: const Icon(Icons.add),
    //         ),
    //       );
    //     }
    //   },
    // ),

    return Scaffold(
        floatingActionButton: Visibility(
          visible: showEdit,
          child: FloatingActionButton(
            heroTag: "EventFloatingActionButton",
            backgroundColor: const Color(constants.primaryColorDark),
            onPressed: () async {
              showAddAnnouncementDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TopNavigationHomeBar(
                    onClickController: onClickController,
                    current: "Announcement"),
                reminderValue.when(
                    data: (announcement) => announcement.isEmpty
                        ? const Center(
                            child: Text("No Announcement"),
                          )
                        :

                        // it is a trick:
                        // We use the whereType method to filter out the null elements and only
                        // keep the non-null Trip objects. Finally, we call toList() to convert
                        // the filtered iterable into a List<Trip>.
                        AnnouncementCard(
                            reminders:
                                announcement.whereType<Announcement>().toList(),
                            ref: ref,
                            context: context),
                    error: (e, st) => const Center(
                          child: Text('Error Here'),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ],
            ),
          ),
        ));
  }
}
