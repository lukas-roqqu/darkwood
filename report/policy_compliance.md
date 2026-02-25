o# Policy & Compliance

> This document details the compliance concerns identified during the research phase of this project. All references point to official, publicly accessible policy documents so they can be independently verified.

---

## The Core Conflict: Apple Pay / Google Pay vs. In-App Virtual Currency

Both Apple and Google maintain a hard architectural separation between their native payment APIs (Apple Pay / Google Pay) and the purchase of digital/virtual goods inside an application. Using Apple Pay or Google Pay to sell in-game tokens would violate the policies of both platforms.

---

## Apple

### Relevant Policy Documents

**1. App Store Review Guidelines — Section 3.1.1: In-App Purchase**
- **URL:** https://developer.apple.com/app-store/review/guidelines/
- **Navigate to:** Business > 3.1.1 In-App Purchase
- **Exact language:**
  > *"If you want to unlock features or functionality within your app (by way of example: subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use in-app purchase."*
  >
  > *"Apps may not use their own mechanisms to unlock content or functionality, such as license keys, augmented reality markers, QR codes, cryptocurrencies and cryptocurrency wallets, etc."*

- **What this means:** In-game tokens/currency are explicitly listed as something that **must** go through Apple's own In-App Purchase (StoreKit) system — not Apple Pay.

**2. App Store Review Guidelines — Section 3.1.3(e): Goods and Services Outside of the App**
- **URL:** https://developer.apple.com/app-store/review/guidelines/
- **Navigate to:** Business > 3.1.3(e)
- **Exact language:**
  > *"If your app enables people to purchase physical goods or services that will be consumed outside of the app, you must use purchase methods other than in-app purchase to collect those payments, such as Apple Pay or traditional credit card entry."*

- **What this means:** Apple Pay is explicitly designated for **physical goods** consumed outside the app only. It is not a route around Apple's IAP system.

**3. Apple Pay Acceptable Use Guidelines — Virtual Currency**
- **URL:** https://developer.apple.com/apple-pay/acceptable-use-guidelines-for-websites/
- **Navigate to:** The prohibited use list
- **Exact language:**
  > *"Involves the purchase or transfer of currency (including cryptocurrencies) **unless approved by Apple**."*

- **What this means:** Any transaction involving virtual currency via Apple Pay is prohibited unless Apple has specifically approved it — an approval not available to standard app developers.

---

## Google

### Relevant Policy Documents

**1. Google Pay and Wallet APIs Acceptable Use Policy — Financial Services**
- **URL:** https://payments.developers.google.com/terms/aup
- **Navigate to:** Prohibited products and services > Financial Services / Cryptocurrency
- **Exact language:**
  > *"Cryptocurrency-related products and services (including ICO/IEO pre-sales, storage wallets or trading information)"* are prohibited.
  >
  > Exception only for: *"the purchase or selling of cryptocurrencies with fiat monies through regulated entities."*

- **What this means:** Token sales via Google Pay are prohibited unless conducted through a regulated financial entity — which does not apply to an in-app game token.

**2. Google Play Payments Policy**
- **URL:** https://support.google.com/googleplay/android-developer/answer/10281818
- **Navigate to:** In-app purchases and virtual currency section
- **Exact language (paraphrased from policy):** Developers that sell digital goods and services in Android apps must use **Google Play In-app Billing**. Examples explicitly include virtual game products and in-app currencies. Google Pay is not an acceptable substitute.

---

## Consequences of Non-Compliance

### Apple

| Consequence | Detail |
|---|---|
| **App rejection** | The app will be rejected during App Store review before it ever reaches users |
| **App removal** | If it passes review and is later flagged, the app is removed from the App Store entirely, including loss of all ratings and download history |
| **Apple Pay disabled** | Apple explicitly reserves the right to *"disable Apple Pay on any website/app at any time for any reason it deems prudent"* |
| **Developer account termination** | Repeated or egregious violations result in termination of the entire Apple Developer account, removing **all** apps associated with it — not just the offending one |
| **Re-enrollment restriction** | Terminated developers cannot re-enroll in the Apple Developer Program for a minimum of one year |

**Sources:** [Apple Developer Program License Agreement](https://developer.apple.com/support/terms/apple-developer-program-license-agreement/) · [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

### Google

| Consequence | Detail |
|---|---|
| **App suspension** | The app is immediately suspended; users can no longer find it on the Play Store and all in-app purchases are disabled |
| **Strike against account** | Each violation adds a strike to the Google Play Developer account |
| **Developer account termination** | Multiple strikes result in permanent termination of the developer account and **all associated accounts** |
| **All apps removed** | On account termination, every app published under that account is removed from Google Play |
| **Google Pay API access revoked** | Google may disable API access for all products under the account |

**Sources:** [Google Play Enforcement Process](https://support.google.com/googleplay/android-developer/answer/9899234) · [Google Pay Acceptable Use Policy](https://payments.developers.google.com/terms/aup)

---

## Summary

| Platform | Policy Violation | Severity |
|---|---|---|
| Apple | Using Apple Pay for in-game tokens bypasses mandatory IAP (§3.1.1) and violates Apple Pay AUP | **High — app rejection guaranteed at review** |
| Google | Using Google Pay for in-game tokens violates Play Billing policy and Google Pay AUP | **High — app suspension and account strikes** |

This does not mean the product cannot be built. It means the payment route must go through **Apple In-App Purchase (StoreKit)** on iOS and **Google Play Billing** on Android, not through the `pay` Flutter package. The remainder of the report documents what a `pay`-based implementation would require, which remains relevant if the intended use case shifts to physical goods or services in the future.

---

*Sources: [App Store Review Guidelines §3.1.1](https://developer.apple.com/app-store/review/guidelines/) · [App Store Review Guidelines §3.1.3(e)](https://developer.apple.com/app-store/review/guidelines/) · [Apple Pay Acceptable Use Guidelines](https://developer.apple.com/apple-pay/acceptable-use-guidelines-for-websites/) · [Apple Developer Program License Agreement](https://developer.apple.com/support/terms/apple-developer-program-license-agreement/) · [Google Pay & Wallet APIs Acceptable Use Policy](https://payments.developers.google.com/terms/aup) · [Google Play Payments Policy](https://support.google.com/googleplay/android-developer/answer/10281818) · [Google Play Enforcement Process](https://support.google.com/googleplay/android-developer/answer/9899234)*
