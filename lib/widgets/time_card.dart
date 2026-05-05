import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_desktop_panel/providers/time_provider.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.tertiary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(96, 0, 0, 0),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      height: 200,
      width: 550,
      child: Center(
        child: Consumer<TimeProvider>(
          builder: (context, timeProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeProvider.currentDate,
                  style: TextStyle(
                    fontSize: 50,
                    height: 1.0,
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onTertiary,
                  ),
                ),
                Text(
                  timeProvider.currentTime,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onTertiary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
