import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/announcement_list_controller.dart';



class AddTripBottomSheet extends HookConsumerWidget {
  AddTripBottomSheet({
    super.key,
  });

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final startDateController = useTextEditingController();
    final endDateController = useTextEditingController();

    return Form(
      key: formGlobalKey,
      child: Container(
        color: Colors.white70,
        padding: EdgeInsets.only(
            top: 15,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("New Vocel Announcement\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Announcement Title",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryLightTeal),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              controller: announcementNameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                const validationError = 'Enter a valid Announcement title';
                if (value == null || value.isEmpty) {
                  return validationError;
                }

                return null;
              },
              autofocus: true,
              autocorrect: false,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Announcement Description",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryLightTeal),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              autofocus: true,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter a valid Description';
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: startDateController,
              autofocus: true,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Start Date",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryLightTeal),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter a valid date';
                }
              },
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(constants.primaryDarkTeal),
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  startDateController.text = DateFormat.yMd().format(pickedDate);
                }
                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  startDateController.text = formattedDate;
                } else {}
              },
            ),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: endDateController,
              autofocus: true,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "End Date",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryLightTeal),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(constants.primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter a valid date';
                }
              },
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(constants.primaryDarkTeal),
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);

                  endDateController.text = formattedDate;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(constants.primaryDarkTeal)),
                ),
                onPressed: () async {
                  final currentState = formGlobalKey.currentState;
                  if (currentState == null) {
                    return;
                  }
                  if (currentState.validate()) {
                    ref.read(tripsListControllerProvider).add(
                      name: announcementNameController.text,
                      description: descriptionController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                    );
                    Navigator.of(context).pop();
                  }
                } //,
            ),
          ],
        ),
      ),
    );
  }
}

