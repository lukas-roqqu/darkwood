# Darkwood Coffee

> A premium artisan coffee store built in Flutter — used to develop and test Apple Pay & Google Pay integration.

---

## About

Darkwood is a specialty coffee brand. This app is the mobile storefront, allowing customers to browse and purchase single-origin beans, signature blends, and brewing equipment using native mobile payments.

This project also serves as a live integration sandbox for the [`pay`](https://pub.dev/packages/pay) Flutter package, covering both **Apple Pay** (iOS) and **Google Pay** (Android).

---

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/ca29fa87-3d2e-43fc-b290-4189568c069b" width="250" />
  <img src="https://github.com/user-attachments/assets/4733bbe5-fb86-4384-b1f7-8c90eba60a35" width="250" />
  <img src="https://github.com/user-attachments/assets/b8c46f56-eb7c-4122-b0f0-e588d83c840c" width="250" />
</p>

---

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter |
| Payments | [`pay ^3.3.0`](https://pub.dev/packages/pay) |
| Bundle ID | `com.lukasio.darkwood` |
| Platforms | iOS · Android |

---

## Project Structure

```
lib/
├── main.dart               # App entry point
android/
├── app/
│   └── src/main/kotlin/com/lukasio/darkwood/
│       └── MainActivity.kt
ios/
└── Runner/
report/
├── executive_summary.md
├── mobile_implementation.md
├── backend_implementation.md
└── policy_compliance.md
```

---

## Payment Integration

This app integrates with the `pay` package to provide a native checkout experience:

- **Apple Pay** — iOS, via PassKit
- **Google Pay** — Android, via Google Pay API

> See [`report/policy_compliance.md`](report/policy_compliance.md) for important notes on platform policy restrictions regarding virtual currency and in-app tokens.

---

## Getting Started

```bash
flutter pub get
flutter run
```

For payment testing, both providers run in `TEST` environment by default. No real charges are made.

---

## Brand

**Darkwood Coffee** — dark roasts, honest craft.
