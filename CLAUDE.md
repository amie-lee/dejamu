# Dejamu

An iOS app that pins the music tied to a place onto a map.

## Rules

- SwiftUI only, iOS 17.0+, SwiftData, `@Observable`
- No third-party libraries other than RevenueCat
- No backend, no login, no sync. Everything stays local
- One screen per view file. Split into subviews once a file passes 200 lines
- Do not propose new features. Implement only what was asked
- English is the project language: docs, commits, and PR descriptions
- Add new files through Xcode. Never hand-edit `.pbxproj`

## Structure

```
dejamu/dejamu/
  Models/       SwiftData models
  Views/        one file per screen
  Services/     iTunesAPI, LocationManager, AudioPlayer, PurchaseManager
  Resources/
```

## Out of scope

- Social features: friends, feed, sharing to other users
- Login, accounts, server sync
- Photo attachments
- Apple Music playback (MusicKit)
- Background location tracking (never request Always authorization)
- A custom dark-mode-only theme system
- A paywall that caps the number of entries

## Commit convention

`type(scope): subject` — imperative mood, lowercase, no trailing period, 72 chars max.

**type**: `feat` `fix` `refactor` `chore` `docs` `style` `test`

**scope**: `entry` `map` `record` `search` `audio` `location` `share` `purchase` `settings` `project`

```
feat(entry): add Entry SwiftData model
feat(map): render entry pins with artwork thumbnails
fix(location): fall back to nil place name when geocoding fails
refactor(map): extract pin view into EntryPinView
```

The body explains **why the choice was made**, not what changed. The what is already in the diff.

## Branches and PRs

- One slice = one branch = one PR (`feat/slice-3-itunes-search`)
- `main` always builds
- No squash merging. Use merge commits or rebase merges — the commit history is part of what gets reviewed
- Branches live 1–3 days. Never keep two open at once (`.pbxproj` conflicts are painful)

## Data model

```swift
@Model
final class Entry {
    var id: UUID
    var createdAt: Date
    var date: Date              // the day being recorded (backdating allowed)
    var note: String            // 140 chars max

    var trackId: Int
    var title: String
    var artist: String
    var artworkURL: String      // 100x100 URL, swapped to 600x600 at render time
    var previewURL: String?
    var appleMusicURL: String?

    var latitude: Double?       // location is entirely optional
    var longitude: Double?
    var placeName: String?      // CLGeocoder reverse geocoding result
}
```

- Never download or redistribute artwork. Store the URL and render with `AsyncImage` (licensing)
- The API returns `100x100bb.jpg`; string-replace it with `600x600bb.jpg`
- Location defaults to ON when recording. It must be toggleable, but the default stays on — otherwise the map never fills up

## Free vs Pro

```
Free : unlimited entries, list view, basic share card
Pro  : full map view, calendar grid, share card themes, widget, recall notifications
```

The principle is **"writing is free, looking back is paid."** Never cap the number of entries.

RevenueCat: one entitlement `pro`, one offering `default`, three products (monthly, yearly, lifetime).

## Project settings

```
NSLocationWhenInUseUsageDescription
  = "기록에 장소를 함께 남기기 위해 위치를 사용합니다."
NSUserNotificationsUsageDescription  (only once P2 notifications land)
```

- The iTunes API is https, so no ATS exceptions are needed
- `PrivacyInfo.xcprivacy` is required (RevenueCat SDK)
