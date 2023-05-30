import 'package:flutter/material.dart';
import 'package:vocel/common/utils/manage_user.dart';

class ChangeGroupDialog extends StatefulWidget {
  final String currentGroup;
  final String currentUserEmail;
  final void Function()? onGroupChanged;

  ChangeGroupDialog({required this.currentGroup, required this.currentUserEmail, required this.onGroupChanged});

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
            title: const Text('Leader'),
            value: 'leader',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Staff'),
            value: 'staff',
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Parent'),
            value: 'parent',
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
        ElevatedButton(
          onPressed: () {
            if (selectedGroup != widget.currentGroup) {
              changeUsersGroups(widget.currentGroup, selectedGroup, widget.currentUserEmail);
            }
            if (widget.onGroupChanged != null) {
              widget.onGroupChanged!();
            }
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

}
