# AGENTS.md — Edge Panel

## Overview

Edge Panel is a desktop dashboard app for a permanently-mounted screen (ARM64 Linux via flutter-pi). It displays weather, time, messages, and events in a **rotated 270°** landscape layout. UI text is primarily in Chinese.

## Architecture

- **Frontend:** Flutter (Dart SDK ^3.11.3), state management via Provider + ChangeNotifier.
- **Backend:** Python submodule in `python/` — FastAPI + python-socketio + uvicorn on port 5000, managed with `uv`.
- **Communication:** Socket.IO for real-time (weather, events, message sync) + HTTP REST for message CRUD.
- **No formal Dart models** — server data consumed as `Map<String, dynamic>`.

## Key Directories

| Path | Purpose |
|---|---|
| `lib/main.dart` | Entry point; wraps app in MultiProvider + RotatedBox(quarterTurns: 3) |
| `lib/pages/` | `home.dart` (main dashboard), `wait.dart` (loading screen) |
| `lib/providers/` | 5 ChangeNotifier providers: Global, Weather, Time, Event, Message |
| `lib/widgets/` | Card widgets: WeatherCard, TimeCard, EventCard (disabled), MessageCard |
| `lib/services/` | `RealtimeSocketService` — singleton Socket.IO client |
| `python/` | Git submodule — FastAPI backend (weather, messages, events) |
| `assets/weather-icons/` | 507 SVG weather icons (numeric codes from QWeather API) |

## Running the Project

```bash
# Backend
cd python && uv sync && uv run python app/main.py
# Or: cd python && docker compose up -d

# Frontend
flutter pub get
flutter run -d linux
```

## Deployment

Target is an **ARM64 Linux embedded device** running `flutter-pi`. VS Code tasks in `.vscode/tasks.json` handle:
- Build via `flutterpi_tool`, rsync to remote host, restart systemd service.
- Docker multi-platform build (arm64 + amd64), push to private registry, remote redeploy.

## API Endpoints (Backend)

- `GET/POST/DELETE /api/messages` — Message CRUD with soft-delete + 20-item history
- `POST /api/messages/upload-image` — Image upload (HEIC conversion supported)
- `POST /api/messages/webhook/notify` — External notification webhook
- `POST /api/messages/clear` — Clear all messages

Socket.IO events: `request_weather`/`weather_data`, `request_event`/`event_data`, `messages_updated`.

## Notable Patterns

- **Rotated display:** Entire UI is `RotatedBox(quarterTurns: 3)`.
- **Timer-driven polling:** Time every 1s, weather/event every 60s, connection check every 1s.
- **Hardcoded location:** 40.09N, 116.31E (Beijing) for sunrise/sunset and weather defaults.
- **Marquee scrolling:** Long text auto-scrolls using `LayoutBuilder` + `TextPainter` overflow detection.
- **Theme:** HSL hue cycling by minute; dark/light mode based on sunrise/sunset calculation.
- **Card UI:** Material 3 with 32px rounded corners, drop shadows, `Consumer` for granular rebuild.

## Testing

Minimal — only the default Flutter boilerplate in `test/widget_test.dart` (does not match current app). No real tests exist for frontend or backend.

## Directory Structure

| Directory | Purpose |
|---|---|
| `lib/` | Flutter Dart source code |
| `lib/pages/` | Page screens (home, wait) |
| `lib/providers/` | ChangeNotifier state providers (Global, Weather, Time, Event, Message) |
| `lib/widgets/` | Reusable UI card widgets (weather, time, event, message) |
| `lib/services/` | Singleton services (Socket.IO client) |
| `lib/utils/` | Utilities (logger) |
| `assets/weather-icons/` | 507 SVG weather icons (QWeather numeric codes) |
| `test/` | Flutter test directory (boilerplate only) |
| `linux/` | Linux desktop runner (GTK/C++) |
| `windows/` | Windows desktop runner (C++) |
| `macos/` | macOS desktop runner (Swift) |
| `android/` | Android platform scaffold (not primary target) |
| `ios/` | iOS platform scaffold (not primary target) |
| `web/` | Web platform scaffold (not primary target) |
| `build/` | Build output artifacts |
| `python/` | Git submodule — FastAPI backend |
| `python/app/` | Backend application code (main, weather/message/event services) |
| `python/web/` | Backend web management interface (HTML, PWA assets) |
| `repo_files/images/` | Repository images (README screenshot) |
| `scripts/` | Scripts directory (currently empty) |
| `.vscode/` | VS Code configuration (build/deploy tasks) |
