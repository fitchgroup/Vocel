import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vocel/common/navigation/router/routes.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/event_controller.dart';
import 'package:vocel/models/ModelProvider.dart';

class EditVocelEventPage extends HookConsumerWidget {
  EditVocelEventPage({
    required this.event,
    super.key,
  });

  final VocelEvent event;

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventNameController =
        useTextEditingController(text: event.eventTitle);
    final descriptionController =
        useTextEditingController(text: event.eventDescription);
    final locationController =
        useTextEditingController(text: event.eventLocation);
    final startDateController = useTextEditingController(
        text: DateFormat('HH:mm yyyy-MM-dd')
            .format(event.startTime.getDateTimeInUtc().toLocal()));
    final durationController =
        useTextEditingController(text: event.duration.toString());
    final selectedRole = useState<String?>(event.eventGroup.name);
    final selectedProfileRole = useState<ProfileRole?>(event.eventGroup);
    final formattedTime = useState<String?>(event.duration.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Vocel Event\n",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            context.goNamed(
              EventRoute.event.name,
              params: {'id': event.id},
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Event Title",
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
                  controller: eventNameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    const validationError = 'Enter a valid Event title';
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
                  decoration: const InputDecoration(
                    hintText: "Event Description",
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
                  controller: descriptionController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return 'Enter a valid Description';
                    }
                  },
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Location",
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
                  keyboardType: TextInputType.text,
                  controller: locationController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return 'Enter a valid date';
                    }
                  },
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Start Date",
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
                  keyboardType: TextInputType.datetime,
                  controller: startDateController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return 'Enter a valid date';
                    }
                  },
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
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
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        pickedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                    }

                    if (pickedDate != null) {
                      startDateController.text =
                          DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
                    }

                    // if (pickedDate != null) {
                    //   String formattedDate =
                    //   DateFormat('yyyy-MM-dd').format(pickedDate);
                    //   startDateController.text = formattedDate;
                    // } else {}
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Duration",
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
                  keyboardType: TextInputType.text,
                  controller: durationController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return 'Enter a valid duration';
                    }
                  },
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 0, minute: 0),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime != null) {
                      String formatTime = '';
                      if (pickedTime.hour > 0) {
                        formatTime +=
                            '${pickedTime.hour} hour${pickedTime.hour > 1 ? 's' : ''}';
                      }
                      if (pickedTime.minute > 0) {
                        if (formatTime.isNotEmpty) {
                          formatTime += ' ';
                        }
                        formatTime +=
                            '${pickedTime.minute} minute${pickedTime.minute > 1 ? 's' : ''}';
                      }
                      durationController.text = formatTime;
                      formatTime =
                          (pickedTime.hour * 60 + pickedTime.minute).toString();
                      formattedTime.value = formatTime;
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      final currentState = formGlobalKey.currentState;
                      if (currentState == null) {
                        return;
                      }
                      if (currentState.validate()) {
                        final updatedEvent = event.copyWith(
                            eventTitle: eventNameController.text,
                            eventDescription: descriptionController.text,
                            eventLocation: locationController.text,
                            startTime: TemporalDateTime(
                                DateTime.parse(startDateController.text)),
                            duration:
                                int.tryParse(formattedTime.value ?? "0") ?? 0);
                        ref.read(eventControllerProvider).edit(updatedEvent);
                        context.goNamed(
                          EventRoute.event.name,
                          params: {'id': event.id},
                        );
                      }
                    } //,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
