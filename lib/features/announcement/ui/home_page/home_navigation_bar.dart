import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class TopNavigationHomeBar extends StatefulWidget {
  const TopNavigationHomeBar({
    super.key,
    required this.onClickController,
    required this.current,
  });

  final onClickController;
  final current;

  @override
  State<TopNavigationHomeBar> createState() =>
      _TopNavigationHomeBarState(onClickController: onClickController);
}

class _TopNavigationHomeBarState extends State<TopNavigationHomeBar> {
  _TopNavigationHomeBarState({required this.onClickController});

  ValueChanged<String> onClickController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white24, // Customize the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              onClickController("Announcement");
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.announcement_outlined,
                    color: widget.current == "Announcement"
                        ? const Color(constants.primaryDarkTeal)
                        : Colors.grey,
                  ), // Trumpet Icon
                  const SizedBox(width: 10),
                  Text(
                    'Announcement',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Pangolin",
                      color: widget.current == "Announcement"
                          ? const Color(constants.primaryDarkTeal)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onClickController("Post");
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.post_add_rounded,
                    color: widget.current == "Post"
                        ? const Color(constants.primaryRegularTeal)
                        : Colors.grey,
                  ), // Trumpet Icon
                  const SizedBox(width: 10),
                  Text(
                    'Post',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Pangolin",
                        color: widget.current == "Post"
                            ? const Color(constants.primaryRegularTeal)
                            : Colors.grey),
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
