import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.colorScheme,
    required this.type,
    required this.data,
    this.onDoubleTap,
  });
  final ColorScheme colorScheme;
  final String type;
  final dynamic data;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "image":
        return MessageImage(
          data: data,
          colorScheme: colorScheme,
          onDoubleTap: onDoubleTap,
        );
      case "text":
        return MessageText(
          data: data,
          colorScheme: colorScheme,
          onDoubleTap: onDoubleTap,
        );
      case "idle":
        return MessageIdle(
          data: data,
          colorScheme: colorScheme,
          onDoubleTap: onDoubleTap,
        );
      case "notify":
        return MessageNotify(
          data: data,
          colorScheme: colorScheme,
          onDoubleTap: onDoubleTap,
        );
      default:
        return Placeholder();
    }
  }
}

class MessageIdle extends StatelessWidget {
  const MessageIdle({
    super.key,
    required this.colorScheme,
    required this.data,
    this.onDoubleTap,
  });
  final List<String> data;
  final ColorScheme colorScheme;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: double.infinity,
        width: 250,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text(
                data[0],
                style: GoogleFonts.notoSansSc(
                  height: 1.1,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 16,
              child: Text(
                data[1],
                style: TextStyle(
                  height: 1.0,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageNotify extends StatelessWidget {
  const MessageNotify({
    super.key,
    required this.colorScheme,
    required this.data,
    this.onDoubleTap,
  });
  final List<String> data;
  final ColorScheme colorScheme;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: double.infinity,
        width: 425,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(96, 0, 0, 0),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 28,
              child: Text(
                data[2],
                style: GoogleFonts.notoSansSc(
                  height: 1.1,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                data[0],
                style: GoogleFonts.notoSansSc(
                  height: 1.1,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 16,
              child: Text(
                data[1],
                style: TextStyle(
                  height: 1.0,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  const MessageText({
    super.key,
    required this.colorScheme,
    required this.data,
    this.onDoubleTap,
  });
  final List<String> data;
  final ColorScheme colorScheme;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: double.infinity,
        width: 425,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(96, 0, 0, 0),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text(
                data[0],
                style: GoogleFonts.notoSansSc(
                  height: 1.1,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 16,
              child: Text(
                data[1],
                style: TextStyle(
                  height: 1.0,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageImage extends StatelessWidget {
  const MessageImage({
    super.key,
    required this.colorScheme,
    required this.data,
    this.onDoubleTap,
  });
  final String data;
  final ColorScheme colorScheme;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: double.infinity,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(data, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
