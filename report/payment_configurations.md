# Payment Configurations
### A comprehensive reference for Apple Pay and Google Pay configuration JSON

> The configurations documented here should **not be hardcoded in the app**. The recommended approach is to store them on your backend and fetch them at runtime — so merchant IDs, supported networks, currencies, and environments can be updated without shipping a new app version. See the note at the bottom of this document.

---

## Apple Pay

### Minimal config (physical goods, no contact fields)

The smallest valid config — suitable when you only need to charge an amount and don't need the customer's address or email.

```json
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.yourcompany.appname",
    "displayName": "Your Business Name",
    "merchantCapabilities": ["3DS"],
    "supportedNetworks": ["visa", "masterCard"],
    "countryCode": "GB",
    "currencyCode": "GBP"
  }
}
```

### Full config (with billing, shipping, and shipping methods)

```json
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.yourcompany.appname",
    "displayName": "Your Business Name",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["visa", "masterCard", "amex", "discover"],
    "countryCode": "GB",
    "currencyCode": "GBP",
    "requiredBillingContactFields": ["postalAddress", "name", "emailAddress", "phoneNumber"],
    "requiredShippingContactFields": ["postalAddress", "name", "emailAddress", "phoneNumber"],
    "shippingMethods": [
      {
        "label": "Standard Delivery",
        "detail": "5–8 Business Days",
        "amount": "2.99",
        "identifier": "standard"
      },
      {
        "label": "Express Delivery",
        "detail": "1–2 Business Days",
        "amount": "6.99",
        "identifier": "express"
      },
      {
        "label": "In-Store Pickup",
        "detail": "Available within an hour",
        "amount": "0.00",
        "identifier": "pickup"
      }
    ]
  }
}
```

### Field Reference — Apple Pay

| Field | Type | Required | Allowed values / notes |
|---|---|---|---|
| `merchantIdentifier` | string | YES | Format: `merchant.com.company.app` — must match Apple Developer Portal and Xcode entitlements |
| `displayName` | string | YES | Shown on the payment sheet as the payee name |
| `merchantCapabilities` | string[] | YES | `"3DS"` always required; `"debit"`, `"credit"`, `"EMV"` optional |
| `supportedNetworks` | string[] | YES | `"visa"`, `"masterCard"`, `"amex"`, `"discover"`, `"interac"`, `"JCB"`, `"mir"`, `"bancontact"`, `"waon"`, `"nanaco"`, `"dankort"`, `"meeza"`, `"NAPAS"`, `"pagoBancomat"`, `"postFinance"`, `"tmoney"`, `"bankAxept"` |
| `countryCode` | string | YES | ISO 3166-1 alpha-2 (e.g. `"GB"`, `"NG"`, `"US"`) |
| `currencyCode` | string | YES | ISO 4217 (e.g. `"GBP"`, `"NGN"`, `"USD"`) |
| `requiredBillingContactFields` | string[] | NO | `"postalAddress"`, `"name"`, `"emailAddress"`, `"phoneNumber"` — only request what you genuinely need |
| `requiredShippingContactFields` | string[] | NO | Same values as billing — Apple rejects apps requesting unnecessary data |
| `shippingMethods` | object[] | NO | Array of shipping options shown on the sheet |

**`shippingMethods` item fields:**

| Field | Type | Notes |
|---|---|---|
| `label` | string | Display name |
| `detail` | string | Subtitle / description |
| `amount` | string | Decimal string e.g. `"4.99"` |
| `identifier` | string | Internal ID used to identify the selected method |

---

## Google Pay

### Minimal config (TEST environment)

```json
{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "environment": "TEST",
    "merchantInfo": {
      "merchantName": "Your Business Name"
    },
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"]
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "gatewayMerchantId": "your_stripe_account_id"
          }
        }
      }
    ],
    "transactionInfo": {
      "countryCode": "GB",
      "currencyCode": "GBP"
    }
  }
}
```

### Full config (PRODUCTION, with billing and shipping)

```json
{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "merchantInfo": {
      "merchantName": "Your Business Name",
      "merchantId": "your_google_pay_merchant_id"
    },
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD", "AMEX"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "gatewayMerchantId": "your_stripe_account_id"
          }
        }
      }
    ],
    "transactionInfo": {
      "countryCode": "GB",
      "currencyCode": "GBP",
      "totalPriceStatus": "FINAL",
      "checkoutOption": "COMPLETE_IMMEDIATE_PURCHASE"
    },
    "emailRequired": true,
    "shippingAddressRequired": true,
    "shippingAddressParameters": {
      "allowedCountryCodes": ["GB", "NG", "US", "GH", "KE"],
      "phoneNumberRequired": true
    }
  }
}
```

### DIRECT tokenization (advanced — requires PCI DSS SAQ D)

Used when you want to process the token yourself without a payment gateway. Only applicable if you are a licensed payment processor or have achieved full PCI DSS compliance.

```json
"tokenizationSpecification": {
  "type": "DIRECT",
  "parameters": {
    "protocolVersion": "ECv2",
    "publicKey": "your_base64_encoded_public_key"
  }
}
```

### Field Reference — Google Pay

| Field | Type | Required | Allowed values / notes |
|---|---|---|---|
| `apiVersion` | number | YES | Always `2` |
| `apiVersionMinor` | number | YES | Always `0` |
| `environment` | string | NO | `"TEST"` during development — remove or set to `"PRODUCTION"` for release |
| `merchantInfo.merchantName` | string | NO | Shown on the payment sheet |
| `merchantInfo.merchantId` | string | Required for PRODUCTION | Obtained from the Google Pay & Wallet Console |
| `allowedPaymentMethods[].type` | string | YES | Only `"CARD"` — only one entry allowed |
| `allowedCardNetworks` | string[] | YES | `"VISA"`, `"MASTERCARD"`, `"AMEX"`, `"DISCOVER"`, `"INTERAC"`, `"JCB"` |
| `allowedAuthMethods` | string[] | YES | `"PAN_ONLY"`, `"CRYPTOGRAM_3DS"` |
| `billingAddressRequired` | boolean | NO | Set `true` if you need billing address |
| `billingAddressParameters.format` | string | NO | `"MIN"` (name + postcode) or `"FULL"` (complete address) |
| `tokenizationSpecification.type` | string | YES | `"PAYMENT_GATEWAY"` (standard) or `"DIRECT"` (advanced, requires PCI DSS) |
| `gateway` | string | YES (gateway) | Your processor's gateway name e.g. `"stripe"`, `"adyen"`, `"braintree"` |
| `gatewayMerchantId` | string | YES (gateway) | Your merchant account ID with that processor |
| `transactionInfo.countryCode` | string | NO | ISO 3166-1 alpha-2 |
| `transactionInfo.currencyCode` | string | YES | ISO 4217 |
| `transactionInfo.totalPriceStatus` | string | NO | `"FINAL"`, `"ESTIMATED"`, `"NOT_FINAL"` |
| `transactionInfo.checkoutOption` | string | NO | `"COMPLETE_IMMEDIATE_PURCHASE"` for immediate charge; `"DEFAULT"` otherwise |
| `emailRequired` | boolean | NO | Collects email address |
| `shippingAddressRequired` | boolean | NO | Collects shipping address |
| `shippingAddressParameters.allowedCountryCodes` | string[] | NO | Restrict shipping to specific countries |

---

## Gateway Names by Processor

When using `PAYMENT_GATEWAY` tokenization, the `gateway` string must match exactly what Google and Apple expect for your processor:

| Processor | Google Pay `gateway` value | Apple Pay |
|---|---|---|
| Stripe | `"stripe"` | Uses payment processing certificate — no gateway string needed |
| Adyen | `"adyen"` | Uses payment processing certificate |
| Braintree | `"braintree"` | Uses payment processing certificate |
| Paystack | Not publicly documented | Uses payment processing certificate |
| Flutterwave | Not publicly documented | Uses payment processing certificate |

---

## Storing Configs on the Backend

**Hardcoding payment configuration in the app is not recommended.** The `pay` package's own documentation flags this explicitly.

The preferred approach is to fetch the configuration JSON from your backend at startup:

```
GET /payments/config
→ { "applePay": { ... }, "googlePay": { ... } }
```

**Why this matters:**

| Reason | Detail |
|---|---|
| **Merchant ID changes** | If you ever need to update or rotate your merchant ID, you can do it server-side without an app release |
| **Network updates** | Adding or removing a supported card network takes effect immediately for all users |
| **Environment switching** | Flipping `"TEST"` to `"PRODUCTION"` in Google Pay config is a server-side change, not a deployment |
| **Multi-region support** | Serve different `countryCode`, `currencyCode`, or supported networks based on the user's region |
| **Processor switching** | Swapping from Stripe to Paystack only requires a config update — the app code stays the same |

```dart
// Fetch config at startup, fall back to bundled defaults if offline
Future<void> _loadPaymentConfig() async {
  try {
    final response = await _http.get('$_backendUrl/payments/config');
    _appleConfig = PaymentConfiguration.fromJsonString(
      jsonEncode(response.body['applePay']),
    );
    _googleConfig = PaymentConfiguration.fromJsonString(
      jsonEncode(response.body['googlePay']),
    );
  } catch (_) {
    // Fall back to bundled config
    _appleConfig = PaymentConfiguration.fromJsonString(_applePayFallback);
    _googleConfig = PaymentConfiguration.fromJsonString(_googlePayFallback);
  }
}
```

---

*Sources: [`pay` Flutter package](https://pub.dev/packages/pay) · [Google Pay Request Objects](https://developers.google.com/pay/api/android/reference/request-objects) · [Apple Pay Implementation Guide](https://developer.apple.com/apple-pay/implementation/) · [PKPaymentNetwork](https://developer.apple.com/documentation/passkit/pkpaymentnetwork)*
