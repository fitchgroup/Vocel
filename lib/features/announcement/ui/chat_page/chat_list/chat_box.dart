import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = Provider<types.User>(
    (ref) => const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac'));
final messagesProvider = Provider<List<types.Message>>((ref) => []);

class ChatPage extends HookConsumerWidget {
  final String myInfo;
  final String theirInfo;
  final String title;

  const ChatPage({
    Key? key,
    required this.myInfo,
    required this.theirInfo,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _loadMessages(WidgetRef ref) async {
      final response = await rootBundle.loadString('assets/messages.json');
      final messages = (jsonDecode(response) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();

      ref.read(messagesProvider).addAll(messages);
    }

    useEffect(() {
      _loadMessages(ref);
    }, []);

    final user = ref.watch(userProvider);
    final messages = ref.watch(messagesProvider);

    void _addMessage(types.Message message) {
      ref.read(messagesProvider).insert(0, message);
    }

    void _handleFileSelection() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final message = types.FileMessage(
          author: user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          mimeType: lookupMimeType(result.files.single.path!),
          name: result.files.single.name,
          size: result.files.single.size,
          uri: result.files.single.path!,
        );

        _addMessage(message);
      }
    }

    void _handleImageSelection() async {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );

      if (result != null) {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);

        final message = types.ImageMessage(
          author: user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
        );

        _addMessage(message);
      }
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
    }

    void _handleMessageTap(BuildContext _, types.Message message) async {
      if (message is types.FileMessage) {
        var localPath = message.uri;

        if (message.uri.startsWith('http')) {
          try {
            final index =
                messages.indexWhere((element) => element.id == message.id);
            final updatedMessage =
                (messages[index] as types.FileMessage).copyWith(
              isLoading: true,
            );

            ref
                .read(messagesProvider)
                .replaceRange(index, index + 1, [updatedMessage]);

            final client = http.Client();
            final request = await client.get(Uri.parse(message.uri));
            final bytes = request.bodyBytes;
            final documentsDir =
                (await getApplicationDocumentsDirectory()).path;
            localPath = '$documentsDir/${message.name}';

            if (!File(localPath).existsSync()) {
              final file = File(localPath);
              await file.writeAsBytes(bytes);
            }
          } finally {
            final index =
                messages.indexWhere((element) => element.id == message.id);
            final updatedMessage =
                (messages[index] as types.FileMessage).copyWith(
              isLoading: null,
            );

            ref
                .read(messagesProvider)
                .replaceRange(index, index + 1, [updatedMessage]);
          }
        }

        await OpenFilex.open(localPath);
      }
    }

    void _handlePreviewDataFetched(
        types.TextMessage message, types.PreviewData previewData) {
      final index = messages.indexWhere((element) => element.id == message.id);
      final updatedMessage = (messages[index] as types.TextMessage).copyWith(
        previewData: previewData,
      );

      ref
          .read(messagesProvider)
          .replaceRange(index, index + 1, [updatedMessage]);
    }

    void _handleSendPressed(types.PartialText message) {
      final textMessage = types.TextMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
      );

      _addMessage(textMessage);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Container(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 6, // Allocate 65% of the available height
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      theirInfo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Pangolin",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4, // Allocate 35% of the available height
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: Chat(
          messages: messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: user,
          showUserAvatars: true,

          /// reference making chat theme
          // attachmentButtonIcon (Widget): Icon for the attachment button.
          // attachmentButtonMargin (EdgeInsets): Margin of the attachment button.
          // backgroundColor (Color): Used as the background color of the chat widget.
          // dateDividerMargin (EdgeInsets): Margin around date dividers.
          // dateDividerTextStyle (TextStyle): Text style of the date dividers.
          // deliveredIcon (Widget): Icon for the delivered status of messages.
          // documentIcon (Widget): Icon inside the file message.
          // emptyChatPlaceholderTextStyle (TextStyle): Text style of the empty chat placeholder.
          // errorColor (Color): Color to indicate an error.
          // errorIcon (Widget): Icon for the error status of messages.
          // inputBackgroundColor (Color): Color of the bottom bar where the text field is.
          // inputBorderRadius (BorderRadius): Top border radius of the bottom bar where the text field is.
          // inputContainerDecoration (Decoration): Decoration of the container wrapping the text field.
          // inputMargin (EdgeInsets): Outer insets of the bottom bar where the text field is.
          // inputPadding (EdgeInsets): Inner insets of the bottom bar where the text field is.
          // inputTextColor (Color): Color of the text field's text and attachment/send buttons.
          // inputTextCursorColor (Color): Color of the text field's cursor.
          // inputTextDecoration (InputDecoration): Decoration of the input text field.
          // inputTextStyle (TextStyle): Text style of the message input.
          // messageBorderRadius (double): Border radius of the message container.
          // messageInsetsHorizontal (double): Horizontal message bubble insets.
          // messageInsetsVertical (double): Vertical message bubble insets.
          // primaryColor (Color): Primary color of the chat used as a background of sent messages and statuses.
          // receivedEmojiMessageTextStyle (TextStyle): Text style used for displaying emojis on received text messages.
          // receivedMessageBodyBoldTextStyle (TextStyle): Body text style used for displaying bold text on received text messages.
          // receivedMessageBodyCodeTextStyle (TextStyle): Body text style used for displaying code text on received text messages.
          // receivedMessageBodyLinkTextStyle (TextStyle): Text style used for displaying link text on received text messages.
          // receivedMessageBodyTextStyle (TextStyle): Body text style used for displaying text on received messages.
          // receivedMessageCaptionTextStyle (TextStyle): Caption text style used for displaying secondary info on received messages.
          // receivedMessageDocumentIconColor (Color): Color of the document icon on received messages.
          // receivedMessageLinkDescriptionTextStyle (TextStyle): Text style used for displaying link description on received messages.
          // receivedMessageLinkTitleTextStyle (TextStyle): Text style used for displaying link title on received messages.
          // secondaryColor (Color): Secondary color used as the background of received messages.
          // seenIcon (Widget): Icon for the seen status of messages.
          // sendButtonIcon (Widget): Icon for the send button.
          // sendButtonMargin (EdgeInsets): Margin of the send button.
          // sendingIcon (Widget): Icon for the sending status of messages.
          // sentEmojiMessageTextStyle (TextStyle): Text style used for displaying emojis on sent text messages.
          // sentMessageBodyBoldTextStyle (TextStyle): Body text style used for displaying bold text.
          theme: DefaultChatTheme(
            backgroundColor: Colors.grey.shade100,
            primaryColor: const Color(constants.primaryColorDark),
            secondaryColor: Colors.grey.shade200,
            inputBackgroundColor: Colors.grey.shade200,
            inputTextColor: Colors.black87,
            inputTextCursorColor: const Color(constants.primaryColorDark),
            messageBorderRadius: 10.0,
            messageInsetsHorizontal: 10.0,
            messageInsetsVertical: 8.0,
            receivedMessageBodyTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
            receivedMessageCaptionTextStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
            receivedMessageLinkTitleTextStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            receivedMessageLinkDescriptionTextStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
            sentMessageBodyTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
            sentMessageCaptionTextStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
            sentMessageLinkTitleTextStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            sentMessageLinkDescriptionTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            attachmentButtonIcon: const Icon(
              Icons.attach_file,
              size: 20,
              color: Color(constants.primaryColorDark),
            ),
            sendButtonIcon: const Icon(
              Icons.send,
              size: 20,
              color: Color(constants.primaryColorDark),
            ),
          )),
    );
  }
}
