import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/event_list/selected_event_card.dart';
import 'package:vocel/models/ProfileRole.dart';
import 'package:vocel/models/VocelEvent.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  final VocelEvent event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String parseMinutesToHourAndMinuteFormat(int minute) {
    int hours = minute ~/ 60;
    int minutes = minute % 60;

    if (hours == 0 && minutes == 0) {
      return "0 minutes";
    } else if (hours == 0) {
      return "$minutes minute${minutes > 1 ? 's' : ''}";
    } else if (minutes == 0) {
      return "$hours hour${hours > 1 ? 's' : ''}";
    } else {
      return "$hours hour${hours > 1 ? 's' : ''} and $minutes minute${minutes > 1 ? 's' : ''}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(constants.primaryDarkTeal).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: widget.event.eventImageUrl != null
                  //   CachedNetworkImage(
                  //   cacheKey: widget.event.eventImageKey,
                  //   imageUrl: widget.event.eventImageUrl!,
                  //   width: double.maxFinite,
                  //   height: 500,
                  //   alignment: Alignment.topCenter,
                  //   fit: BoxFit.fill,
                  // )
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.event.eventImageUrl!,
                        cacheKey: widget.event.eventImageKey,
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    )
                  : const DecorationImage(
                      image: AssetImage('images/vocel_logo.png'),
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.eventTitle,
                        style: GoogleFonts.montserrat(
                          color:
                              Color(constants.darkerThanPrimaryDarkTealColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black87,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Date & Time: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(constants
                                              .darkerThanPrimaryDarkTealColor),
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat('yyyy-MM-d HH:mm')
                                            .format(widget.event.startTime
                                                .getDateTimeInUtc()
                                                .toLocal()),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), // Date and Time
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: Colors.black87,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Duration: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(constants
                                              .darkerThanPrimaryDarkTealColor),
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text: parseMinutesToHourAndMinuteFormat(
                                            widget.event.duration),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), // Duration
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.black87,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Location / Zoom Link: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(constants
                                              .darkerThanPrimaryDarkTealColor),
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.event.eventLocation,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), // Location / Zoom Link
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueGrey.shade600,
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignCenter),
                      // Add black border
                      color: widget.event.eventGroup == ProfileRole.ALL ||
                              widget.event.eventGroup == ProfileRole.STAFF
                          ? const Color(constants.primaryColorDark)
                          : (widget.event.eventGroup == ProfileRole.BELL ||
                                  widget.event.eventGroup == ProfileRole.EETC ||
                                  widget.event.eventGroup == ProfileRole.VCPA)
                              ? const Color(constants.primaryRegularTeal)
                              : Colors.grey[350],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      ["ALL", "STAFF", "BELL", "EETC", "VCPA"]
                              .contains(widget.event.eventGroup.name)
                          ? widget.event.eventGroup.name
                          : "NOT ASSIGNED",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "Pangolin"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
                Text(
                  widget.event.eventDescription,
                  style: const TextStyle(
                    color: Color(0xFF0A1931),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SelectedEventCard(event: widget.event),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
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
