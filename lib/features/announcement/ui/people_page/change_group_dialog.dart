import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/manage_user.dart';

class ChangeGroupDialog extends StatefulWidget {
  final String currentGroup;
  final String currentUserEmail;
  final void Function()? onGroupChanged;

  ChangeGroupDialog(
      {required this.currentGroup,
      required this.currentUserEmail,
      required this.onGroupChanged});

  @override
  _ChangeGroupDialogState createState() => _ChangeGroupDialogState();
}

class _ChangeGroupDialogState extends State<ChangeGroupDialog> {
  late String selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Groups'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('STAFF'),
            value: 'Staffversion1',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('BELL'),
            value: 'Bellversion1',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('EETC'),
            value: 'Eetcversion1',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('VCPA'),
            value: 'Vcpaversion1',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Dismiss the dialog and don't delete
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedGroup != widget.currentGroup) {
              changeUsersGroups(
                  widget.currentGroup, selectedGroup, widget.currentUserEmail);
            }
            if (widget.onGroupChanged != null) {
              widget.onGroupChanged!();
            }
            Navigator.of(context).pop(false); // Close the dialog
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
