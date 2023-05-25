import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(constants.primaryDarkTeal).withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: const DecorationImage(
                      image: AssetImage('images/vocel_logo.png'),
                      fit: BoxFit.cover,
                      opacity: 0.5
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Title',
                        style: GoogleFonts.montserrat(
                          color: Color(constants.darkerThanPrimaryDarkTealColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children:  [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black87,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Date & Time',
                            style: TextStyle(
                              color: Color(constants.darkerThanPrimaryDarkTealColor),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.location_on,
                            color: Colors.black87,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Event Location',
                            style: TextStyle(
                              color: Color(constants.darkerThanPrimaryDarkTealColor),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      const LocalizedMessageResolver().eventDescription(context),
                      style: const TextStyle(
                        fontFamily: "Pangolin",
                        color: Color(0xFF0A1931),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting',
                      style: TextStyle(
                        color: Color(0xFF0A1931),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button press to register for the event
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: const Color(constants.primaryDarkTeal),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            const LocalizedMessageResolver().registerForEvent(context),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Montserrat', // Custom font family
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            const LocalizedMessageResolver().shareOnSocialMedia(context),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialMediaButton(
                            onPressed: () {
// Handle social media sharing to Facebook
                            },
                            icon: const Icon(
                              Icons.facebook,
                              size: 20,
                            ),
                            color: const Color(0xFF3b5998),
                          ),
                          _buildSocialMediaButton(
                            onPressed: () {
// Handle social media sharing to Twitter
                            },
                            icon: const Icon(
                              Icons.post_add,
                              size: 20,
                            ),
                            color: const Color(0xFF1da1f2),
                          ),
                          _buildSocialMediaButton(
                            onPressed: () {
// Handle social media sharing to Instagram
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 20,
                            ),
                            color: const Color(0xFFc13584),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}

Widget _buildSocialMediaButton({
  required VoidCallback onPressed,
  required Icon icon,
  required Color color,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
    ),
  );
}