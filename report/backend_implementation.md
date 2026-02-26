# Implementation Overview
### Mobile and Backend — How the System Works

---

## System Architecture

The complete payment system spans two codebases that work together:

```
┌─────────────────────────────────┐        ┌──────────────────────────────┐
│         Flutter App             │        │       NestJS Backend          │
│         (Darkwood)              │        │       (Whitewood)             │
│                                 │        │                               │
│  User taps Apple/Google Pay btn │        │  POST /payments/process       │
│  ↓                              │        │  ↓                            │
│  Native payment sheet shown     │  HTTP  │  Validate request (DTO)       │
│  ↓                              │ ─────► │  ↓                            │
│  User authenticates (FaceID etc)│        │  Create PaymentMethod (Stripe)│
│  ↓                              │        │  ↓                            │
│  Encrypted token returned       │        │  Create + confirm PaymentIntent│
│  ↓                              │◄────── │  ↓                            │
│  Show success / error           │        │  Return { id, status }        │
└─────────────────────────────────┘        └──────────────────────────────┘
                                                         │
                                                         ▼
                                              ┌─────────────────┐
                                              │  Stripe (or     │
                                              │  other processor│
                                              │  e.g. Paystack) │
                                              └─────────────────┘
```

The app never touches money directly. It collects a **token** from the device and hands it to the backend. The backend is the only place that interacts with the payment processor.

---

## Mobile — Flutter App

### What's needed

| Requirement | Detail |
|---|---|
| `pay` Flutter package | Added to `pubspec.yaml`; provides the native Apple Pay / Google Pay buttons |
| Apple Pay config JSON | Merchant ID, supported networks, country, currency |
| Google Pay config JSON | Gateway name, merchant name, environment, allowed networks |
| `PayService` | State management wrapper around the `pay` package |
| Platform-aware UI | `ApplePayButton` on iOS, `GooglePayButton` on Android |

### How it's carried out

**1. Configuration**

Each provider needs a JSON configuration object that describes who the merchant is and what the payment sheet should display. This is loaded once at app startup via `PaymentConfiguration.fromJsonString()` and cached.

```dart
// Apple Pay — minimum required fields
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.yourcompany.app",
    "displayName":        "Your Business Name",
    "merchantCapabilities": ["3DS"],
    "supportedNetworks":    ["visa", "masterCard", "amex"],
    "countryCode":   "GB",
    "currencyCode":  "GBP"
  }
}

// Google Pay — minimum required fields
{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2, "apiVersionMinor": 0,
    "environment": "TEST",
    "merchantInfo": { "merchantName": "Your Business Name" },
    "allowedPaymentMethods": [{
      "type": "CARD",
      "parameters": {
        "allowedCardNetworks":  ["VISA", "MASTERCARD"],
        "allowedAuthMethods":   ["PAN_ONLY", "CRYPTOGRAM_3DS"]
      },
      "tokenizationSpecification": {
        "type": "PAYMENT_GATEWAY",
        "parameters": {
          "gateway":           "stripe",
          "gatewayMerchantId": "your_stripe_account_id"
        }
      }
    }],
    "transactionInfo": { "countryCode": "GB", "currencyCode": "GBP" }
  }
}
```

**2. Payment Items**

Before the button renders, you build a list of `PaymentItem` objects describing what the user is paying for. These appear on the native payment sheet. The last item must represent the total.

```dart
[
  PaymentItem(label: 'Under Milk Wood · 250g', amount: '12.75', type: PaymentItemType.item),
  PaymentItem(label: 'Total',                  amount: '12.75', type: PaymentItemType.total),
]
```

`amount` is always a **string** with a period as the decimal separator (`"12.75"`, not `12.75` and not `"12,75"`).

**3. Button**

The button is placed at the correct point in the UI. It handles the entire native flow internally — showing the payment sheet, waiting for authentication, and returning the result.

```dart
Platform.isIOS
  ? ApplePayButton(
      paymentConfiguration: payService.applePayConfig,
      paymentItems: paymentItems,
      onPaymentResult: (result) => payService.onPaymentResult(result),
      onError: payService.onPaymentError,
    )
  : GooglePayButton(
      paymentConfiguration: payService.googlePayConfig,
      paymentItems: paymentItems,
      onPaymentResult: (result) => payService.onPaymentResult(result),
      onError: payService.onPaymentError,
    )
```

The button auto-hides if the user cannot pay (no cards in Wallet, capability not configured, unsupported device). Use `childOnError` to show a fallback widget in that case.

**4. Result handling**

`onPaymentResult` receives a `Map<String, dynamic>` containing the encrypted token. The app immediately POSTs this to the backend — it does not attempt to charge the token itself.

```
Apple Pay token map key:  result['token']
Google Pay token map key: result['paymentMethodData']['tokenizationData']['token']
```

The app sets a loading/processing state while waiting for the backend response, then shows success or an error message.

**5. Error handling**

| Error code | Action |
|---|---|
| `paymentCanceled` | Silent reset to idle — user dismissed the sheet, no message needed |
| `paymentFailed` | Show error message |
| `invalidPaymentConfiguration` | Log and investigate — config JSON is malformed |
| Any other | Show generic error message |

---

## Backend — NestJS (Whitewood)

### What's needed

| Requirement | Detail |
|---|---|
| Node.js + NestJS | Server framework |
| Stripe SDK (`stripe` npm package) | Payment processor integration |
| `@nestjs/config` | Loads `.env` into the app |
| `class-validator` | Validates incoming request bodies |
| HTTPS in production | Both Apple and Google reject HTTP endpoints |
| Stripe secret key | In `.env` — never committed to source control |

### How it's carried out

**1. Receive and validate the request**

The Flutter app sends a `POST /payments/process` with a JSON body. The DTO defines exactly what's accepted:

```typescript
class ProcessPaymentDto {
  token:       string   // encrypted payment token from the device
  provider:    'apple_pay' | 'google_pay'
  amount:      number   // in smallest currency unit (e.g. pence): 1275 = £12.75
  description: string   // e.g. "Darkwood Coffee · 250g"
}
```

NestJS's `ValidationPipe` (with `whitelist: true`) rejects any request that doesn't match this shape before it reaches the service.

**2. Create a PaymentMethod**

The encrypted token is submitted to Stripe to create a `PaymentMethod` object:

```typescript
const paymentMethod = await stripe.paymentMethods.create({
  type: 'card',
  card: { token: dto.token },
});
```

Stripe handles decrypting the token using the payment processing certificate you registered with them. This is why you need to generate a CSR from Stripe's dashboard and upload it to Apple Developer Portal — without that certificate pair, Stripe cannot decrypt the token.

**3. Create and confirm a PaymentIntent**

The `PaymentMethod` is used to create a `PaymentIntent` — Stripe's representation of a single payment attempt — and immediately confirmed:

```typescript
const intent = await stripe.paymentIntents.create({
  amount:           dto.amount,       // in pence
  currency:         'gbp',
  payment_method:   paymentMethod.id,
  description:      dto.description,
  confirm:          true,
  automatic_payment_methods: { enabled: true, allow_redirects: 'never' },
});
```

**4. Return the result**

If `intent.status === 'succeeded'`, the endpoint returns `{ id, status }` with HTTP 200. The Flutter app reads this and moves to the success state. Any failure throws a `BadRequestException` or `InternalServerErrorException` which NestJS serialises to a 400/500 response — the Flutter app reads the status code and shows an error.

**5. Environment and secrets**

```
# whitewood/.env
STRIPE_SECRET_KEY=sk_test_...   ← test key for development
                  sk_live_...   ← live key in production server only
```

The `.env` file is gitignored. The live key is never in source control and never in the app. In production, inject it via your hosting provider's environment variable management.

---

## How They Connect

The only contract between the app and the backend is the HTTP request:

```
POST http(s)://<server>/payments/process
Content-Type: application/json

{
  "token":       "<encrypted token string>",
  "provider":    "apple_pay",
  "amount":      1275,
  "description": "Darkwood Coffee · Under Milk Wood · 250g"
}
```

And the response:

```json
// Success (200)
{ "id": "pi_abc123", "status": "succeeded" }

// Failure (400/500)
{ "statusCode": 400, "message": "Invalid payment token: ..." }
```

This clean separation means:
- The Flutter app and `pay` package integration is **processor-agnostic** — swapping Stripe for Paystack only requires changes to the backend
- The backend can be replaced, rewritten, or scaled independently of the app
- No payment credentials ever exist on the device

---

## Development vs Production

| | Development | Production |
|---|---|---|
| Apple Pay token | Simulated (from Simulator) or real sandbox token (physical device + sandbox card) | Real encrypted token from device |
| Google Pay token | `"examplePaymentMethodToken"` (TEST env) | Real encrypted token |
| Backend URL | Local IP (e.g. `http://192.168.1.x:3000`) | HTTPS domain |
| Stripe key | `sk_test_...` | `sk_live_...` |
| Google Pay environment | `"TEST"` in config JSON | `"PRODUCTION"` (or field removed) |
| Transport security | `NSAllowsLocalNetworking: true` in Info.plist | Standard HTTPS — no exception needed |

---

*Sources: [`pay` Flutter package](https://pub.dev/packages/pay) · [Stripe PaymentIntents](https://docs.stripe.com/api/payment_intents) · [Stripe Apple Pay](https://docs.stripe.com/apple-pay) · [Stripe Google Pay](https://docs.stripe.com/google-pay) · [Google Pay Request Objects](https://developers.google.com/pay/api/android/reference/request-objects) · [Apple Pay Implementation Guide](https://developer.apple.com/apple-pay/implementation/)*
