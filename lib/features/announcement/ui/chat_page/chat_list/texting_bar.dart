import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/controller/message_list_controller.dart';

class TextingBar extends HookConsumerWidget {
  final senderInfo;
  final receiverInfo;

  TextingBar({
    super.key,
    required this.senderInfo,
    required this.receiverInfo,
  });

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentController = useTextEditingController();
    // final focusNode = useState(FocusNode());
    // final hasFocus = useState(false);
    final changing = useState(false);

    void _handleFileSelection() async {
      // final result = await FilePicker.platform.pickFiles(
      //   type: FileType.any,
      // );
      //
      // if (result != null && result.files.single.path != null) {
      //   final thisMessage = VocelMessage(
      //       content: result.files.single.name,
      //       sender: myInfo,
      //       receiver: theirInfo,
      //       attachedLink: result.files.single.path!);
      //
      //   ref.read(messagesProvider).insert(0, thisMessage);
      // }
    }

    void _handleImageSelection() async {
      // final result = await ImagePicker().pickImage(
      //   imageQuality: 70,
      //   maxWidth: 1440,
      //   source: ImageSource.gallery,
      // );
      //
      // if (result != null) {
      //   final bytes = await result.readAsBytes();
      //   final image = await decodeImageFromList(bytes);
      //
      //   final thisMessage = VocelMessage(
      //       content: result.name,
      //       sender: myInfo,
      //       receiver: theirInfo,
      //       attachedLink: result.path);
      //
      //   ref.read(messagesProvider).insert(0, thisMessage);
      // }
    }

    void _handleAttachmentPressed() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Request focus when attachment is pressed
      // focusNode.value.requestFocus();
    }

    // useEffect(() {
    //   // Print the focus state after the widget rebuilds
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     print('Focus State: ${focusNode.value.hasFocus}');
    //   });
    // }, [focusNode]);

    return Form(
      key: formGlobalKey,
      child: Container(
        color: Colors.grey.shade100,
        padding: EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _handleAttachmentPressed,
              child: const IconButton(
                icon: Icon(
                  Icons.attach_file,
                  size: 20,
                  color: Color(constants.primaryColorDark),
                ),
                onPressed: null,
              ),
            ),
            Expanded(
              child: TextFormField(
                // focusNode: focusNode.value,
                decoration: InputDecoration(
                  hintText: "Message...",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                controller: contentController,
                keyboardType: TextInputType.text,
                onTap: () {
                  // if (!focusNode.value.hasFocus)
                  //   focusNode.value.requestFocus();
                  // else
                  //   focusNode.value.unfocus();
                  changing.value = !changing.value;
                  print(changing.value);
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return 'You forgot to input messages ${Emojis.smile_winking_face}...';
                  }
                },
                autocorrect: false,
                autofocus: changing.value,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 15),
            IconButton(
              icon: const Icon(
                Icons.send,
                size: 20,
                color: Color(constants.primaryColorDark),
              ),
              onPressed: () async {
                final currentState = formGlobalKey.currentState;
                if (currentState == null) {
                  return;
                }
                if (currentState.validate()) {
                  ref.read(messagesListControllerProvider).add(
                        messageContent: contentController.text,
                        messageSender: senderInfo,
                        messageReceiver: receiverInfo,
                      );
                  print(senderInfo);
                  print(receiverInfo);
                  print('&' * 100);
                }
                contentController.clear();
                // Dismiss the keyboard and unfocus the field
                // focusNode.value.unfocus();
                changing.value = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
