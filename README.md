<p align="center">
  <img src="dejamu/dejamu/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png" width="88" alt="Dejamu app icon">
</p>

<p align="center">
  <img src="dejamu/dejamu/Assets.xcassets/Wordmark.imageset/Wordmark.png" width="320" alt="dejamu">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0%2B-FF5AA8?style=flat-square&labelColor=2b2b2b" alt="iOS 17.0+">
  <img src="https://img.shields.io/badge/SwiftUI-100%25-FF5AA8?style=flat-square&labelColor=2b2b2b" alt="SwiftUI">
  <img src="https://img.shields.io/badge/backend-none-FF5AA8?style=flat-square&labelColor=2b2b2b" alt="No backend">
</p>

<p align="center"><b>Fill your own map with music.</b></p>

An archive app that pins the music tied to a place onto your map.

Drop one song and a short note wherever you are. As the entries pile up, the map
turns into your own timeline of music. No account, no friends, no feed —
everything stays on your device.

## Stack

| Area | Choice |
|---|---|
| Minimum version | iOS 17.0+ |
| UI | SwiftUI |
| State | `@Observable` (iOS 17 Observation) |
| Local storage | SwiftData |
| Map | MapKit (`Map(position:)` + `Annotation`) |
| Music data | iTunes Search API |
| Audio | AVPlayer (30s preview) |
| Payments | RevenueCat |
| Backend | None. Fully local |

## Running it locally

1. **Xcode 16 or later**, targeting iOS 17.0+. The project uses Xcode 16's file-system-synchronized
   groups, so new files are picked up automatically without editing `project.pbxproj`.
2. Open `dejamu/dejamu.xcodeproj` and let Xcode resolve the one Swift Package dependency
   (RevenueCat) automatically on first build.
3. In **Signing & Capabilities**, select your own Team for both the `dejamu` and
   `DejamuWidgetExtension` targets (automatic signing works fine, no paid developer account
   needed for local runs).
4. Both targets need the same **App Group** capability
   (`group.com.sy.dejamu`) so the widget can read the same SwiftData store as the main app.
   Xcode should carry this over from the checked-in entitlements files; if the widget builds but
   shows no data, re-check that the App Group is enabled on both targets under the same Team.
5. Run on the iOS Simulator for the core app, but check search, location, silent-switch audio,
   the widget, and recall notifications on a **physical device** — several of these either behave
   differently in the Simulator or can't be exercised there at all (Simulator has no hardware
   mute switch, and its location and network behavior don't always match a real device).

## Progress

- [x] **1** Project setup + SwiftData `Entry` model + 3 dummy entries → *three pins show on the map*
- [x] **2** RecordSheet (text input only) → save → *core loop complete*
- [x] **3** iTunes Search API + preview playback → *the chosen song's artwork becomes a pin*
- [x] **4** Location permission + coordinates + reverse geocoding → *pins land on my actual location*
- [x] **5** EntryDetailView + edit/delete → *CRUD complete*
- [x] **6** Bottom sheet + weekly strip + list/calendar → *home screen complete*
- [x] **7** Share card → *an image comes out*
- [x] **8** RevenueCat + paywall + gating → *sandbox purchase goes through*
- [x] **9** Onboarding / settings / empty states / error handling → *a first-time user doesn't get lost*
- [x] **10** Widget · recall notifications (if time allows)

## Screens

**P0** — HomeMapView · RecordSheet · SongSearchView · EntryDetailView
**P1** — EntryListView / CalendarView · ShareCardView · PaywallView · SettingsView
**P2** — Widget · geofence recall notifications · onboarding
