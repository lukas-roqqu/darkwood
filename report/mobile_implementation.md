# Mobile Implementation
### What the Flutter app needs and how it's wired together

---

## Overview

The mobile side has four concerns:

1. **Configuration** — tell the `pay` package who you are (merchant identity, currency, networks)
2. **Payment items** — tell the payment sheet what the user is buying and how much
3. **The button** — render the correct native button and handle the result
4. **State** — track whether a payment is idle, processing, succeeded, or failed

---

## 1. Configuration JSON

Each provider requires a JSON object loaded into a `PaymentConfiguration` at startup. The two configs are separate — one for Apple Pay, one for Google Pay.

For the complete field reference, all config variations (minimal, full, with shipping, DIRECT tokenization), and a guide on storing configs on the backend, see [`payment_configurations.md`](./payment_configurations.md).

### Key points

- `merchantIdentifier` (Apple) must match the Merchant ID in your Apple Developer Portal **and** your Xcode entitlements — mismatch means the button won't appear on device
- `environment: "TEST"` (Google) must be changed to `"PRODUCTION"` before release — in TEST mode the button shows an "Unrecognised App" warning and always returns a dummy non-chargeable token
- Only list `supportedNetworks` and `allowedCardNetworks` that your payment processor actually supports
- Only request contact fields (`requiredBillingContactFields` etc.) that you genuinely need — Apple rejects apps asking for unnecessary data

### Loading the config

```dart
// Loaded once at init and cached
PaymentConfiguration.fromJsonString(applePayJsonString);
PaymentConfiguration.fromJsonString(googlePayJsonString);
```

> **Recommendation:** fetch the config JSON from your backend rather than hardcoding it in the app. This lets you update merchant IDs, networks, currencies, and environments without shipping a new app version. See [`payment_configurations.md`](./payment_configurations.md) for the fetch pattern.

---

## 2. Payment Items

`PaymentItem` objects represent each line item on the payment sheet. They are rebuilt every time the cart changes (quantity, size selection, etc.) so the sheet always shows the correct amount.

```dart
List<PaymentItem> buildItems(ProductVariant variant, int quantity) {
  final total = (variant.price * quantity).toStringAsFixed(2);
  return [
    PaymentItem(
      label: '${product.name} · ${variant.label}',
      amount: (variant.price * quantity).toStringAsFixed(2),
      type: PaymentItemType.item,
      status: PaymentItemStatus.final_price,
    ),
    PaymentItem(
      label: 'Total',
      amount: total,
      type: PaymentItemType.total,
      status: PaymentItemStatus.final_price,
    ),
  ];
}
```

**Rules:**
- `amount` must be a **string**, using a period as the decimal separator — `"12.75"`, never `12.75` or `"12,75"`
- The **last item** in the list is treated as the total by iOS; set its `type` to `PaymentItemType.total`
- `status: PaymentItemStatus.final_price` shows the amount as confirmed; `pending` shows a `~` prefix on iOS

---

## 3. The Button

The button is platform-specific. Use `Platform.isIOS` to decide which to render.

```dart
import 'dart:io';
import 'package:pay/pay.dart';

// Inside your widget build method:
Platform.isIOS
    ? ApplePayButton(
        paymentConfiguration: payService.applePayConfig,
        paymentItems: paymentItems,
        height: 54,
        cornerRadius: 27,
        style: ApplePayButtonStyle.black,
        type: ApplePayButtonType.buy,
        onPaymentResult: (result) => payService.onPaymentResult(result),
        onError: payService.onPaymentError,
        childOnError: Text('Apple Pay not available'),
      )
    : GooglePayButton(
        paymentConfiguration: payService.googlePayConfig,
        paymentItems: paymentItems,
        height: 54,
        theme: GooglePayButtonTheme.dark,
        type: GooglePayButtonType.buy,
        onPaymentResult: (result) => payService.onPaymentResult(result),
        onError: payService.onPaymentError,
        childOnError: Text('Google Pay not available'),
      )
```

**Button behaviour:**
- The button calls `userCanPay()` internally when it first renders
- If the user cannot pay (no cards, capability not set up), the button renders nothing — or `childOnError` if you provide one
- Once the user taps, the native payment sheet appears and handles everything (card selection, biometric auth)
- `onPaymentResult` is called only after a successful authorisation

### Checking availability manually

If you need to know payment availability before the button renders (e.g. to show/hide an entire section), use the `Pay` class directly:

```dart
Pay({PayProvider.apple_pay: payService.applePayConfig})
    .userCanPay(PayProvider.apple_pay)
    .then((canPay) => setState(() => _canPay = canPay));
```

---

## 4. Handling the Result

`onPaymentResult` receives a raw `Map<String, dynamic>`. The token location differs by provider:

### Apple Pay result

```
result['token']                 → encrypted token string (empty on Simulator)
result['transactionIdentifier'] → "Simulated Identifier" on Simulator, unique ID on device
result['paymentMethod']         → card brand, display name
result['shippingContact']       → if requiredShippingContactFields was set
result['billingContact']        → if requiredBillingContactFields was set
```

### Google Pay result

```
result['paymentMethodData']['tokenizationData']['token'] → gateway token string
result['paymentMethodData']['description']               → e.g. "Visa •••• 1234"
result['paymentMethodData']['type']                      → "CARD"
result['email']                                          → if emailRequired was true
result['shippingAddress']                                → if shippingAddressRequired was true
```

The token is sent to your backend — it is **never charged client-side**.

---

## 5. Error Handling

```dart
void onPaymentError(Object? error) {
  if (error is PlatformException && error.code == 'paymentCanceled') {
    // User dismissed the sheet — silent reset, no message
    status.value = PaymentStatus.idle;
    return;
  }
  // Any other error — show the user a message
  status.value = PaymentStatus.failed;
  lastError.value = error?.toString() ?? 'Payment failed';
}
```

| Error code | Meaning | Action |
|---|---|---|
| `paymentCanceled` | User dismissed the sheet | Silent reset to idle |
| `paymentFailed` | Auth started but didn't complete | Show error |
| `invalidPaymentConfiguration` | Config JSON is malformed | Fix the JSON |
| `paymentResultDeserializationFailed` | iOS couldn't serialise the token | Rare; log and investigate |

---

## 6. iOS Platform Setup

Beyond the Dart code, two things must be configured natively:

### Xcode — Apple Pay Entitlement

In Xcode → Runner target → Signing & Capabilities → **+ Capability** → Apple Pay. Add your merchant ID. Xcode writes this to `Runner.entitlements`:

```xml
<key>com.apple.developer.in-app-payments</key>
<array>
    <string>merchant.com.yourcompany.appname</string>
</array>
```

Without this entitlement, `canMakePayments()` returns `false` on real devices and the button never appears.

### Info.plist — Local Networking (development only)

To allow HTTP calls to your local backend during development:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

Remove this (or leave it — it has no effect) once you switch to an HTTPS backend in production.

---

## 7. Android Platform Setup

Google Pay requires no changes to `AndroidManifest.xml` for the `pay` package. Ensure:

- `minSdkVersion` is **23** or higher in `android/app/build.gradle`
- `compileSdkVersion` is **34** or higher
- The app is distributed through the **Google Play Store** — sideloaded APKs cannot use production Google Pay

---

*Sources: [`pay` Flutter package](https://pub.dev/packages/pay) · [Apple Pay Implementation Guide](https://developer.apple.com/apple-pay/implementation/) · [Google Pay Request Objects](https://developers.google.com/pay/api/android/reference/request-objects) · [Google Pay Android Setup](https://developers.google.com/pay/api/android/guides/setup)*
