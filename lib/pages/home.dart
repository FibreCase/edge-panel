import 'package:edge_panel/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:edge_panel/widgets/weather_card.dart';
import 'package:edge_panel/widgets/time_card.dart';
import 'package:edge_panel/providers/message_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 255,
                    child: WeatherCard(colorScheme: colorScheme),
                  ),
                  const SizedBox(height: 24),
                  Expanded(child: EventCard(colorScheme: colorScheme)),
                ],
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 550,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TimeCard(colorScheme: colorScheme),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.hardEdge,
                      children: [
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
          ],
        ),
      ),
    );
  }
}
