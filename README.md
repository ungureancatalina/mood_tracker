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

4. This is how the app looks like:


![Screenshot 2025-07-02 213419](https://github.com/user-attachments/assets/5a2a23ed-c0b5-4e84-8b28-1a450bd04d57)
![Screenshot 2025-07-02 213425](https://github.com/user-attachments/assets/0e921e22-f43c-47af-a1f0-905197d941c1)
![Screenshot 2025-07-02 213529](https://github.com/user-attachments/assets/7c221858-ba2d-41e8-9553-356ab91e088e)
![Screenshot 2025-07-02 213541](https://github.com/user-attachments/assets/7826d642-5d36-4fe2-a737-42c702fc5ff8)
![Screenshot 2025-07-02 213606](https://github.com/user-attachments/assets/7e78f73d-197b-4a4f-abd3-1f63897aee2c)
![Screenshot 2025-07-02 213708](https://github.com/user-attachments/assets/cd632c6d-a483-4a98-aa8b-6b227795d930)
![Screenshot 2025-07-02 213714](https://github.com/user-attachments/assets/e37da794-60da-4ecf-9c20-96935e7778e3)

   
