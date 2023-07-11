import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:vocel/common/ui/upload_progress_dialog.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/controller/user_attribute_controller.dart';

class ProfilePic extends HookConsumerWidget {
  final profileHeight;

  ProfilePic({Key? key, required this.profileHeight}) : super(key: key);

  Future<File?> chooseImage(WidgetRef ref, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(image.path);
      final newImage = File('${directory.path}/$name');
      return File(image.path).copy(newImage.path);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        print("Fail to add image");
      }
      return null;
    }
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          Navigator.of(context).pop(ImageSource.camera),
                      child: const Text('Camera')),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          Navigator.of(context).pop(ImageSource.gallery),
                      child: const Text('Gallery')),
                ],
              ));
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  ),
                ],
              ));
    }
  }

  Future<void> uploadAvatarImage({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<String?> avatarKey,
    required ValueNotifier<String?> avatarUrl,
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
    await ref.read(userAttributeControllerProvider).uploadAvatarFile(file);

    // Fetch and update avatarKey and avatarUrl after a successful upload.
    var attributes = await getUserAttributesFromBackend(ref);
    avatarKey.value = attributes['key'];
    avatarUrl.value = attributes['url'];
  }

  Future<Map<String, String>> getUserAttributesFromBackend(
      WidgetRef ref) async {
    Map<String, String> stringMap = await getUserAttributes();
    String myAvatarKey = "";
    String myAvatarUrl = "";

    for (var entry in stringMap.entries) {
      if (entry.key == "custom:avatarKey") {
        myAvatarKey = entry.value;
      } else if (entry.key == "custom:avatarUrl") {
        myAvatarUrl = entry.value;
      } else {
        continue;
      }
    }

    return {"key": myAvatarKey, "url": myAvatarUrl};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get avatarKey and avatarUrl state.
    final avatarKey = useState<String?>("");
    final avatarUrl = useState<String?>("");

    useEffect(() {
      // The function getUserAttributesFromBackend is invoked within this async function
      Future fetchAttributes() async {
        var attributes = await getUserAttributesFromBackend(ref);
        avatarKey.value = attributes['key'];
        avatarUrl.value = attributes['url'];
      }

      fetchAttributes();

      return () {}; // The clean-up function to run when the widget is unmounted or updated
    }, const []); // The second argument are dependencies. It's an empty list, so the effect will run once on mount.

    Widget displayImage;
    if (avatarKey.value != "" && avatarUrl.value != "") {
      displayImage = Image(
        image: CachedNetworkImageProvider(
          avatarUrl.value!,
          cacheKey: avatarKey.value,
        ),
        fit: BoxFit.cover,
        height: double.parse(profileHeight) * 1.5,
        width: double.parse(profileHeight) * 1.5,
      );
    } else {
      displayImage = Image(
        fit: BoxFit.cover,
        height: double.parse(profileHeight) * 1.5,
        width: double.parse(profileHeight) * 1.5,
        image: AssetImage('images/vocel_logo.png'),
      );
    }

    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: Colors.grey[100],
        ),
        child: InkWell(
          onTap: () async {
            uploadAvatarImage(
              context: context,
              ref: ref,
              avatarKey: avatarKey,
              avatarUrl: avatarUrl,
            ).then((value) => Navigator.of(context, rootNavigator: true).pop());
          },
          child: displayImage,
        ),
      ),
    );
  }
}
