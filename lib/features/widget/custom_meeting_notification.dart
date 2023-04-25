import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeetingNotification extends StatelessWidget {
  const MeetingNotification({Key? key, this.isReminder = false}) : super(key: key);

  final bool isReminder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 56,
            width: 56,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("images/vocel_logo.png"),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "Meeting with",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600,
                      ),
                      children: [
                        const TextSpan(
                          text: " Jakcy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tomorrow at 10:00 AM : 1d",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "images/vocel_logo.png",
            height: 56,
            width: 56,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
