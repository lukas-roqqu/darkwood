# Executive Summary
### Implementing Apple Pay and Google Pay in a Flutter Application using the `pay` Package

---

## Project Purpose

An exploratory exercise to document, from first principles, what it takes to integrate Apple Pay and Google Pay into a Flutter application using the [`pay`](https://pub.dev/packages/pay) package. The output is a working implementation alongside a set of reference documents a team can use to plan and execute a production integration.

---

## What Was Built

**Flutter app (Darkwood Coffee)** — a demo e-commerce app exercising the full payment flow: product listing, description screen, Apple Pay on iOS and Google Pay on Android, and graceful handling of cancellation and errors.

**NestJS backend (Whitewood)** — a lightweight server that receives the payment token from the app, submits it to Stripe to create and confirm a `PaymentIntent`, and returns the result.

---

## Package Overview

| | |
|---|---|
| **Package** | `pay` |
| **Version** | 3.3.0 (2025-11-21) |
| **Publisher** | google.dev (verified) — Apache-2.0 |
| **Platforms** | iOS (Apple Pay), Android (Google Pay) |
| **Repository** | https://github.com/google-pay/flutter-plugin |

Not an officially supported Google product, per their own README.

---

## How It Works

Neither Apple Pay nor Google Pay charge the card from the device. The device produces an **encrypted payment token** after the user authenticates — the app sends that token to a backend, the backend submits it to a payment processor, and the processor moves the money.

The `pay` package handles the device side only. Everything after the token is the developer's responsibility.

---

## Policy Compliance

**Using Apple Pay or Google Pay to sell digital or virtual goods violates both Apple and Google policy.** These must go through Apple In-App Purchase (StoreKit) and Google Play Billing respectively. Apple Pay and Google Pay are for physical goods and services only.

Consequences include app rejection, payment access revoked, and developer account termination. Full details: [`policy_compliance.md`](./policy_compliance.md)

---

## Integration Requirements

Five things must be in place simultaneously for a production integration:

| Area | Key requirement |
|---|---|
| **Apple Developer account** | Merchant ID registered; payment processing certificate generated |
| **Google Pay & Wallet Console** | Production access approved before going live |
| **Payment processor** | KYC approved; Apple Pay certificate uploaded; Google Pay gateway configured |
| **Backend** | HTTPS; idempotency keys; webhook verification; no tokens logged |
| **Flutter app** | Xcode entitlement; correct config JSON; platform-specific buttons |

Lead time from zero: **up to two weeks** (D-U-N-S verification, KYC, Google Pay production approval). Full checklist: [`integration_checklist.md`](./integration_checklist.md)

---

## Payment Processors

| Processor | Apple Pay | Google Pay | Africa | Best for |
|---|---|---|---|---|
| **Stripe** | ✓ | ✓ | Limited | Most teams globally |
| **Paystack** | ✓ | — | ✓ | African businesses |
| **Flutterwave** | ✓ | ✓ | ✓ | African businesses, multi-method |
| **Adyen** | ✓ | ✓ | Limited | Enterprise |
| **Braintree** | ✓ | ✓ | Limited | PayPal ecosystem |
| **RavenPay** | ✗ | ✗ | ✓ | Not applicable |

RavenPay has no Apple Pay or Google Pay token processing support. Full analysis: [`payment_processors.md`](./payment_processors.md)

---

## Key Observations

- The Apple Pay button renders on the iOS Simulator but returns a simulated empty token — real end-to-end testing requires a physical device with a sandbox card in Wallet
- Payment configuration JSON should be **fetched from the backend**, not hardcoded — this allows merchant IDs, networks, and environments to be updated without an app release
- `PaymentItem.amount` is a string, always with a period decimal separator (`"12.99"`)
- Google Pay in production only works in apps distributed through the **Google Play Store**

---

## Documents in This Project

| Document | What it covers |
|---|---|
| [`policy_compliance.md`](./policy_compliance.md) | Apple and Google policy violations, exact quotes, consequences |
| [`integration_checklist.md`](./integration_checklist.md) | Every step needed to go from zero to production |
| [`mobile_implementation.md`](./mobile_implementation.md) | Flutter app implementation — buttons, items, errors, platform setup |
| [`payment_configurations.md`](./payment_configurations.md) | Full Apple Pay and Google Pay config JSON reference |
| [`backend_implementation.md`](./backend_implementation.md) | How the mobile and backend connect end-to-end |
| [`payment_processors.md`](./payment_processors.md) | What processors are, comparison, and RavenPay analysis |
| [`references.md`](./references.md) | All sources cited across this project |

---

*Sources: [`pay` Flutter package](https://pub.dev/packages/pay) · [Apple Pay Developer Documentation](https://developer.apple.com/apple-pay/) · [Google Pay API Documentation](https://developers.google.com/pay/api) · [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) · [Google Pay Acceptable Use Policy](https://payments.developers.google.com/terms/aup)*
