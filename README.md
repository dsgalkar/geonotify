# 🏛️ CivicPulse — Hyper-Local Civic Transparency Engine

> **Hackathon Project** | Government Infrastructure Transparency via Geo-fencing

---

## 📖 Problem Statement

Citizens are often unaware of government infrastructure projects happening in their vicinity — hospitals, metro lines, roads, and water grids. CivicPulse solves this by building a **geo-fencing system** around public development sites that triggers **location-aware notifications** explaining the work completed and its civic impact.

---

## 🚀 Features

### 👤 Citizen App
- **Interactive Map** — All government projects on Google Maps with color-coded geo-fence circles
- **Live Location Tracking** — Background geo-fencing with 50m movement resolution
- **Smart Notifications** — Triggered automatically when you enter a project's geo-fence zone
- **Project Detail Cards** — Progress bars, civic impact metrics, budget transparency, update timelines
- **Feed View** — Scrollable list of nearby active & completed projects
- **Alerts Tab** — All geo-fence triggered notifications in one place

### 🏛️ Admin Dashboard
- **Project Management** — Add, edit, delete government projects
- **4-Step Project Form** — Category → Location → Budget → Impact metrics
- **Map-based Location Picker** — Tap anywhere on map to set project location
- **Adjustable Geo-fence** — Slider to configure notification radius (100m–2000m)
- **Budget Overview** — Sanctioned vs utilized across all projects
- **Filter & Search** — By category, status, department

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry, role selector (Citizen / Admin)
├── theme.dart                   # Colors, typography, AppConstants
├── models/
│   └── project.dart             # CivicProject, CivicImpact, ProjectUpdate models + sample data
├── services/
│   ├── geofence_service.dart    # Location tracking + Haversine geofence logic + notifications
│   └── project_provider.dart   # State management (ChangeNotifier) + SharedPreferences
└── screens/
    ├── citizen/
    │   ├── citizen_home_screen.dart    # Bottom nav: Feed | Map | Alerts
    │   ├── map_screen.dart             # Google Maps + draggable bottom sheet
    │   └── project_detail_screen.dart # Full project detail with civic impact
    └── admin/
        ├── admin_dashboard_screen.dart # Dashboard with stats + project list
        └── add_project_screen.dart     # 4-step stepper form with map picker
```

---

## ⚙️ Setup

### 1. Flutter Setup
```bash
flutter pub get
```

### 2. Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Maps SDK for Android** and **Maps SDK for iOS**
3. Create an API key
4. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/AppDelegate.swift` (add `GMSServices.provideAPIKey("YOUR_KEY")`)

### 3. Firebase (for push notifications)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Run
```bash
flutter run
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `google_maps_flutter` | Map display with markers & geo-fence circles |
| `geolocator` | Real-time GPS + distance calculation |
| `flutter_local_notifications` | On-device geo-fence triggered alerts |
| `firebase_messaging` | Remote push notifications from admin |
| `provider` | State management |
| `shared_preferences` | Local project data persistence |
| `flutter_animate` | Smooth UI animations |
| `uuid` | Unique project ID generation |

---

## 🔬 Geo-fencing Implementation

The app uses the **Haversine formula** to calculate distance between the user's GPS coordinates and each project site. When the user enters a project's configured radius (100m–2000m), a local notification fires automatically.

```dart
// Haversine distance in meters
double distance = _calculateDistance(userLat, userLon, projectLat, projectLon);
if (distance <= project.geofenceRadius) {
  _sendNotification(project, distance.toInt());
}
```

Location is polled every 50m of movement for battery efficiency.

---

## 🎯 Demo Flow (Hackathon)

1. Open app → Select **Citizen**
2. Allow location permission
3. See map with all government projects + geo-fence circles
4. Tap a project marker → Full civic impact detail
5. Go back → Select **Government Official**
6. See admin dashboard with stats + budget overview
7. Tap **+ Add Project** → Fill 4-step form, pick location on map, set geo-fence radius
8. Project appears live on citizen map

---

## 👥 Team

Built for **Smart India Hackathon** | Problem ID: **25060**  
*Real-time waste management & public infrastructure transparency*

---

*CivicPulse — Making government work visible to every citizen.*
# geonotify
