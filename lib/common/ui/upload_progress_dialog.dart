import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocel/features/announcement/controller/event_controller.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class UploadProgressDialog extends ConsumerWidget {
  const UploadProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ValueListenableBuilder(
          valueListenable: ref.read(eventControllerProvider).uploadProgress(),
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(constants.primaryRegularTeal),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${(double.parse(value.toString()) * 100).toInt()} %',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.all(20),
                    child: LinearProgressIndicator(
                      value: double.parse(value.toString()),
                      backgroundColor: Colors.grey,
                      color: const Color(constants.primaryDarkTeal),
                      minHeight: 10,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
