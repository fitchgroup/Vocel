import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/announcement_list_controller.dart';
import 'package:vocel/models/ModelProvider.dart';

class AddTripBottomSheet extends HookConsumerWidget {
  AddTripBottomSheet({
    super.key,
  });

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedRole = useState<String?>('ALL');
    final selectedProfileRole = useState<ProfileRole?>(ProfileRole.ALL);

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
            const Text(
              "New Vocel Announcement\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ExpansionTile(
              title: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(constants.primaryDarkTeal),
                      width:
                          1.0, // Adjust the width of the border line as needed
                    ),
                  ),
                ),
                child: Text(
                  'Visible To : ${selectedRole.value.toString()}',
                  style: const TextStyle(
                    color: Color(constants.primaryDarkTeal),
                  ),
                ),
              ),
              children: [
                ListTile(
                  title: const Text('ALL GROUPS'),
                  leading: Radio<String>(
                    value: 'ALL',
                    groupValue: selectedRole.value,
                    onChanged: (value) {
                      selectedProfileRole.value = ProfileRole.ALL;
                      selectedRole.value = value;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('STAFF ONLY'),
                  leading: Radio<String>(
                    value: 'STAFF',
                    groupValue: selectedRole.value,
                    onChanged: (value) {
                      selectedProfileRole.value = ProfileRole.STAFF;
                      selectedRole.value = value;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('BELL'),
                  leading: Radio<String>(
                    value: 'BELL',
                    groupValue: selectedRole.value,
                    onChanged: (value) {
                      selectedProfileRole.value = ProfileRole.BELL;
                      selectedRole.value = value;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('EETC'),
                  leading: Radio<String>(
                    value: 'EETC',
                    groupValue: selectedRole.value,
                    onChanged: (value) {
                      selectedProfileRole.value = ProfileRole.EETC;
                      selectedRole.value = value;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('VCPA'),
                  leading: Radio<String>(
                    value: 'VCPA',
                    groupValue: selectedRole.value,
                    onChanged: (value) {
                      selectedProfileRole.value = ProfileRole.VCPA;
                      selectedRole.value = value;
                    },
                  ),
                ),
              ],
            ),
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
                    color: Color(constants
                        .primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              controller: announcementNameController,
              keyboardType: TextInputType.text,
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
              height: 15,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
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
                    color: Color(constants
                        .primaryDarkTeal), // set the focused border color here
                  ),
                ),
              ),
              autofocus: true,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter a valid Description';
                }
              },
            ),
            const SizedBox(
              height: 15,
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
                          profile: selectedProfileRole.value!,
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
