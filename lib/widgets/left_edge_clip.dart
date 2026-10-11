import 'package:flutter/material.dart';

/// Clips overflow at the left edge while allowing it elsewhere on screen.
class LeftEdgeClip extends StatelessWidget {
  const LeftEdgeClip({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    // Cover the visible screen even when the dashboard is rotated.
    final overflowExtent = screenSize.width + screenSize.height;
    return ClipRect(clipper: _LeftEdgeClipper(overflowExtent), child: child);
  }
}

class _LeftEdgeClipper extends CustomClipper<Rect> {
  const _LeftEdgeClipper(this.overflowExtent);

  final double overflowExtent;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(
    0,
    -overflowExtent,
    size.width + overflowExtent,
    size.height + overflowExtent,
  );

  @override
  bool shouldReclip(_LeftEdgeClipper oldClipper) =>
      overflowExtent != oldClipper.overflowExtent;
}
