import 'package:flutter/material.dart';
import 'package:desk_panel/widgets/weather_card.dart';
import 'package:desk_panel/widgets/time_card.dart';
import 'package:desk_panel/widgets/event_card.dart';
import 'package:desk_panel/providers/message_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WeatherCard(colorScheme: colorScheme),
                const SizedBox(width: 24),
                TimeCard(colorScheme: colorScheme),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  // EventCard(colorScheme: colorScheme),
                  // const SizedBox(width: 24),
                  Consumer<MessageProvider>(
                    builder: (context, messageProvider, child) {
                      return messageProvider.currentMessageWidget;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
