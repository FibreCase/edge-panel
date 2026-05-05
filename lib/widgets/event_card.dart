import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:desk_panel/providers/event_provider.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        return Container(
          width: 250,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(96, 0, 0, 0),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color.fromARGB(96, 0, 0, 0),
                        //     blurRadius: 8,
                        //     offset: const Offset(0, 6),
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Text(
                          eventProvider.nextEventTime,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 36,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      eventProvider.nextEventDate,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 28,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textStyle = GoogleFonts.notoSansSc(
                      fontSize: 28,
                      color: colorScheme.onPrimaryContainer,
                    );
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: eventProvider.nextEventName,
                        style: textStyle,
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    );
                    textPainter.layout();

                    if (textPainter.width > constraints.maxWidth) {
                      return SizedBox(
                        height: 34,
                        child: Marquee(
                          text: eventProvider.nextEventName,
                          style: textStyle,
                          scrollAxis: Axis.horizontal,
                          blankSpace: 60.0,
                          velocity: 40.0,
                          pauseAfterRound: const Duration(milliseconds: 800),
                          startPadding: 0.0,
                        ),
                      );
                    }

                    return Text(
                      eventProvider.nextEventName,
                      textAlign: TextAlign.center,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  "@" + eventProvider.nextEventLocation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansSc(
                    fontSize: 24,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
