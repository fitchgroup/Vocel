import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/post_list_controller.dart';

class AddPostBottomSheet extends HookConsumerWidget {
  final userEmail;
  final currentGroup;

  AddPostBottomSheet(
      {super.key, required this.userEmail, required this.currentGroup});

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentController = useTextEditingController();

    return SingleChildScrollView(
      child: Form(
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
                "New Post\n",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Edit Post Content",
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
                controller: contentController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return 'Enter a valid Description';
                  }
                },
                autofocus: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
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
                      ref.read(postsListControllerProvider).add(
                            postAuthor: userEmail,
                            postContent: contentController.text,
                            postGroup: currentGroup,
                          );
                      Navigator.of(context).pop();
                    }
                  } //,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
