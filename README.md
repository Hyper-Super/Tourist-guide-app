# tOURIST Guide 🌍

A cross-platform mobile travel app built with Flutter that lets users discover destinations, plan trips, book tickets, and save their favourite places — all backed by Firebase.

---

## Features

- **Onboarding** — A 3-step illustrated intro for first-time users
- **Authentication** — Email/password sign-up and login via Firebase Auth
- **Home Screen** — Browse destinations with search and category filters (All, Popular, Mountains, Beaches, Cities)
- **Destination Detail** — Full description, rating, images, and map location
- **Explore Map** — Interactive world map (Flutter Map / OpenStreetMap) with destination markers
- **Booking** — Select a date and number of tickets, confirm and store bookings in Firestore
- **My Bookings** — View and cancel upcoming trips
- **Favourites** — Bookmark destinations and access them from a dedicated screen
- **Profile** — View account info and log out
- **Help & Support** — FAQ section with common questions

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3 / Dart |
| State Management | Provider |
| Backend | Firebase (Auth, Firestore, Storage) |
| Maps | flutter_map + OpenStreetMap |
| Fonts | Google Fonts (Poppins) |
| Images | cached_network_image |
| Local Storage | shared_preferences |
| Date Formatting | intl |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, Firebase init, providers
├── models/
│   └── destination.dart       # Destination data model + Firestore serialization
├── providers/
│   └── app_state.dart         # AuthProvider, BookmarkProvider, DestinationProvider
├── data/
│   └── dummy_data.dart        # Fallback data when Firestore is unavailable
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── explore_screen.dart
│   ├── detail_screen.dart
│   ├── booking_screen.dart
│   ├── my_bookings_screen.dart
│   ├── favorites_screen.dart
│   ├── profile_screen.dart
│   └── help_support_screen.dart
└── widgets/
    ├── bottom_nav_bar.dart
    └── destination_card.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.7`
- Dart SDK `^3.10.7`
- A Firebase project with **Authentication**, **Firestore**, and **Storage** enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/tourist-guide.git
   cd tourist-guide
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a project
   - Add an Android app and download `google-services.json` → place it in `android/app/`
   - Add an iOS app and download `GoogleService-Info.plist` → place it in `ios/Runner/`
   - Enable **Email/Password** under Authentication → Sign-in methods
   - Create a `destinations` collection in Firestore (see schema below)

4. **Run the app**
   ```bash
   flutter run
   ```

> The app includes dummy data fallbacks so it will still run if Firebase is not configured.

---

## Firestore Schema

### `destinations` collection
```
{
  name:        string,
  city:        string,
  country:     string,
  imageUrl:    string,
  description: string,
  rating:      number,
  latitude:    number,
  longitude:   number
}
```

### `bookings` collection
```
{
  userId:          string,
  destinationId:   string,
  destinationName: string,
  date:            timestamp,
  tickets:         number,
  totalPrice:      number
}
```

### `bookmarks` sub-collection (under each user)
```
users/{userId}/bookmarks/{destinationId}
```

---

## Theme

| Role | Color |
|---|---|
| Primary | `#0F2C59` (Deep Navy) |
| Secondary | `#DAC0A3` (Sand/Gold) |
| Background | `#F8F0E5` (Cream) |
| Font | Poppins (Google Fonts) |

---

## Dependencies

```yaml
provider: ^6.1.1
firebase_core: ^3.10.1
firebase_auth: ^5.4.1
cloud_firestore: ^5.6.1
firebase_storage: ^12.3.6
flutter_map: ^8.3.0
latlong2: ^0.9.1
google_fonts: ^8.1.0
cached_network_image: ^3.4.1
shared_preferences: ^2.2.3
intl: ^0.19.0
```

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## License

This project is for educational and personal use. Feel free to fork and build on it.
