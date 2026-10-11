import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edge_panel/providers/action_button_provider.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Color.fromARGB(96, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Consumer<ActionButtonProvider>(
        builder: (context, buttonProvider, child) => ElevatedButton(
          onPressed: buttonProvider.handlePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ).copyWith(elevation: const WidgetStatePropertyAll(0)),
          child: Text(
            buttonProvider.buttonText,
            style: const TextStyle(
              height: 1.0,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
