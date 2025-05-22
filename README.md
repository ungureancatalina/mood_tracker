## About the Project

**Mood Tracker** is a mobile application developed using **Flutter** and **Dart**, designed to help users monitor their emotional well-being over time. The app lets users log moods, write notes, and review emotional trends in a clean and minimal interface.

Instead of a traditional database, data is stored **locally in CSV and JSON files**, making the app lightweight and completely offline.

---

## Technologies Used

| Tool         | Purpose                                |
|--------------|----------------------------------------|
| Flutter      | Cross-platform mobile development      |
| Dart         | Core application logic                 |
| CSV / JSON   | Persistent local storage of mood data  |
| Path Provider| Access to local file system            |

---

## Features

- Log mood entries with optional notes
- Daily mood tracking across multiple screens
- Save and load data in CSV or JSON format
- Local file storage ensures data privacy
- Authentication pages (login/signup)
- Simple navigation and clean interface

---

## Project Structure

```
mood_tracker/
├── lib/
│   ├── main.dart            -> App entry point
│   ├── mood_storage.dart    -> JSON/CSV save & load logic
│   ├── save_load.dart       -> File I/O and data utilities
│   ├── database.dart        -> Data models & helpers
│   ├── login_page.dart      -> Login screen
│   ├── signup_page.dart     -> Account creation screen
│   ├── start_page.dart      -> Main dashboard
│   ├── page2.dart           -> Mood entry or visualization
│   ├── page3.dart           -> Additional screen (e.g., chart)
│   └── start/               -> (If folder) custom widgets/layouts
```

---

## How to Run

### Requirements

- Flutter SDK (latest stable)
- Android Studio, VS Code, or any Flutter-compatible IDE
- A connected device or emulator

### Steps

1. Clone the repository:
```bash
git clone https://github.com/ungureancatalina/mood_tracker
cd mood_tracker
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```
