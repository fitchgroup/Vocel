import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocel/common/ui/upload_progress_dialog.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

import 'package:vocel/features/announcement/controller/event_controller.dart';
import 'package:vocel/models/ModelProvider.dart';

class SelectedEventCard extends ConsumerWidget {
  const SelectedEventCard({
    required this.event,
    super.key,
  });

  final VocelEvent event;

  Future<void> uploadImage({
    required BuildContext context,
    required WidgetRef ref,
    required VocelEvent event,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

    final file = File(pickedFile.path);
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const UploadProgressDialog();
        });
    await ref.read(eventControllerProvider).uploadFile(file, event);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// DONE: TAKE THIS FUNCTION TO EVENT CARD INSTEAD OF SELECTED_EVENT_CARD
          // Container(
          //   alignment: Alignment.center,
          //   color: const Color(constants.primaryColorDark), //Color(0xffE1E5E4),
          //   height: 150,
          //
          //   child: event.eventImageUrl != null
          //       ? Stack(children: [
          //           const Center(child: CircularProgressIndicator()),
          //           CachedNetworkImage(
          //             cacheKey: event.eventImageKey,
          //             imageUrl: event.eventImageUrl!,
          //             width: double.maxFinite,
          //             height: 500,
          //             alignment: Alignment.topCenter,
          //             fit: BoxFit.fill,
          //           ),
          //         ])
          //       : Image.asset(
          //           'images/vocel_logo.png',
          //           fit: BoxFit.contain,
          //         ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  uploadImage(
                    context: context,
                    event: event,
                    ref: ref,
                  ).then((value) =>
                      Navigator.of(context, rootNavigator: true).pop());
                },
                icon: const Icon(Icons.camera_enhance_sharp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
