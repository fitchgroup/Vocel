import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/post_list_controller.dart';
import 'package:vocel/models/Post.dart';

class AddCommentBottomSheet extends HookConsumerWidget {
  final userEmail;
  final relatedPost;

  AddCommentBottomSheet(
      {super.key, required this.userEmail, required this.relatedPost});

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentController = useTextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Comments\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Divider(
                      height: 1,
                      color: Colors.black26,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Add a comment",
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
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter a valid comment';
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
                        'Post',
                        style:
                            TextStyle(color: Color(constants.primaryDarkTeal)),
                      ),
                      onPressed: () async {
                        final currentState = formGlobalKey.currentState;
                        if (currentState == null) {
                          return;
                        }
                        if (currentState.validate()) {
                          ref.read(postsListControllerProvider).addComment(
                              commentAuthor: userEmail,
                              commentContent: contentController.text,
                              relatedPost: relatedPost);
                          Navigator.of(context).pop();
                        }
                      } //,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
