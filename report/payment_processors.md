# Payment Processors
### What they are, the common options, what you need to use them, and a note on RavenPay

---

## What is a Payment Processor?

A payment processor is the company that sits between your application and the customer's bank and physically moves the money.

When a customer pays with Apple Pay or Google Pay, what your app receives is an **encrypted payment token** — a one-time blob that represents the customer's card details without exposing them. That token does nothing on its own. You send it to a payment processor, who:

1. Decrypts the token using a certificate registered with Apple or Google
2. Submits the charge to the relevant card network (Visa, Mastercard, etc.)
3. The card network contacts the customer's issuing bank for authorisation
4. Funds are settled and eventually transferred to your bank account

Without a payment processor, you would need direct agreements with every card network and bank — which requires being a licensed financial institution. Payment processors abstract all of that.

---

## The Common Payment Processors

### Stripe
**Best for:** Most teams. Excellent developer experience, comprehensive documentation, and first-class support for both Apple Pay and Google Pay tokens out of the box.

| | |
|---|---|
| **Apple Pay support** | Yes — full token processing |
| **Google Pay support** | Yes — full token processing |
| **Coverage** | 46+ countries |
| **African coverage** | South Africa, Kenya, Ghana, Nigeria (limited) |
| **Fees** | 1.4–2.9% + fixed fee per transaction (varies by country) |

**What you need to use it:**
- Create an account at [stripe.com](https://stripe.com)
- Complete KYC: business name, registered address, owner details, bank account
- A Certificate Signing Request (CSR) downloaded from the Stripe dashboard — uploaded to Apple Developer Portal to generate your Apple Pay payment processing certificate
- Test keys available immediately; live keys unlocked after KYC review (usually same day)
- HTTPS backend to call their API

---

### Paystack
**Best for:** African businesses, especially those operating in Nigeria, Ghana, Kenya, South Africa, or Côte d'Ivoire. Acquired by Stripe in 2020 but operates independently.

| | |
|---|---|
| **Apple Pay support** | Yes — available in Nigeria, Ghana, Kenya, South Africa, Côte d'Ivoire |
| **Google Pay support** | Not publicly documented |
| **Coverage** | Nigeria, Ghana, Kenya, South Africa, Côte d'Ivoire |
| **Fees** | 1.5% local (Nigeria) + ₦100 cap; 3.9% + ₦100 for international |

**What you need to use it:**
- Create an account at [paystack.com](https://paystack.com)
- Business registration documents (CAC in Nigeria, or equivalent)
- Bank account in the country of registration
- KYC: director/owner ID, proof of address
- Apple Pay domain verification through the Paystack dashboard
- Test keys available immediately; live keys after document review (1–3 business days)

---

### Flutterwave
**Best for:** African businesses wanting broader multi-country coverage with support for local payment methods (mobile money, bank transfer, USSD) alongside card payments.

| | |
|---|---|
| **Apple Pay support** | Yes |
| **Google Pay support** | Yes |
| **Coverage** | 30+ African countries + international |
| **Fees** | 1.4% local; 3.8% international; 2% surcharge on Apple/Google Pay international transactions |

**What you need to use it:**
- Create an account at [flutterwave.com](https://flutterwave.com)
- Business registration documents
- Bank account in a supported country
- KYC: ID documents, proof of business address
- API keys from the developer dashboard
- Live access granted after compliance review (1–3 business days)

---

### Adyen
**Best for:** Large enterprises with high transaction volumes. More complex to set up but highly configurable and global.

| | |
|---|---|
| **Apple Pay support** | Yes — full token processing |
| **Google Pay support** | Yes — full token processing |
| **Coverage** | Global (200+ countries) |
| **Fees** | Interchange++ pricing (lower per-transaction, setup fees apply) |

**What you need to use it:**
- Apply for a merchant account via [adyen.com](https://adyen.com) — not self-serve
- Business registration, projected transaction volume, and processing history required
- Dedicated onboarding process (can take 1–3 weeks)
- Typically requires a minimum monthly volume to be viable

---

### Braintree (PayPal)
**Best for:** Businesses already in the PayPal ecosystem, or those that want PayPal as a payment option alongside cards.

| | |
|---|---|
| **Apple Pay support** | Yes |
| **Google Pay support** | Yes |
| **Coverage** | 45+ countries |
| **African coverage** | Limited |
| **Fees** | 2.59% + $0.49 per transaction (US); varies internationally |

**What you need to use it:**
- Create an account at [braintreepayments.com](https://braintreepayments.com)
- Business details and bank account
- KYC via PayPal's compliance process
- Test environment available immediately; live after review

---

## Can RavenPay Handle This?

**Short answer: No — not at this time.**

Raven (operating as [getravenbank.com](https://getravenbank.com)) is a Nigerian fintech company with a strong consumer banking product and a business-facing API called **Raven ATLAS**, which offers banking-as-a-service capabilities including virtual accounts, transfers, and web payment flows.

However, after reviewing their public developer resources and GitHub organisation ([RavenPayAfrica](https://github.com/RavenPayAfrica)), there is **no documented support for Apple Pay or Google Pay token processing**. Their ATLAS product exposes a web payment link/checkout flow — not a token processing API compatible with the wallet payment flow used by the `pay` Flutter package.

| Capability | RavenPay |
|---|---|
| Receive Apple Pay encrypted token | Not supported |
| Receive Google Pay encrypted token | Not supported |
| Process card payments via their own checkout | Yes |
| Banking-as-a-service (virtual accounts, transfers) | Yes |
| African market focus | Yes — primarily Nigeria |
| Public developer API | Yes (ATLAS) |
| SDKs | Node.js, React/Next.js |

### Why this matters technically

Apple Pay and Google Pay each produce an encrypted token using a **payment processing certificate** registered to a specific processor. The processor you use must have generated that certificate and registered it with Apple or Google. Raven has not published any such capability, which means their infrastructure cannot decrypt or charge these tokens even if they were sent to them.

### What this means for this project

If the intended market is Nigeria and surrounding African countries, **Paystack** or **Flutterwave** are the correct choices — both operate in that region and both have documented Apple Pay support, with Flutterwave also covering Google Pay. The NestJS backend built in this project would simply swap Stripe's SDK for the relevant processor's SDK; the Flutter app and `pay` package integration remain unchanged.

If and when Raven ATLAS adds Apple Pay / Google Pay token processing to their API, the same backend architecture would apply.

---

## Comparison Summary

| Processor | Apple Pay | Google Pay | Africa | Best for |
|---|---|---|---|---|
| **Stripe** | ✓ | ✓ | Limited | Most teams globally |
| **Paystack** | ✓ | — | ✓ Nigeria, Ghana, Kenya, SA, CI | African businesses |
| **Flutterwave** | ✓ | ✓ | ✓ 30+ countries | African businesses, multi-method |
| **Adyen** | ✓ | ✓ | Limited | Enterprise, high volume |
| **Braintree** | ✓ | ✓ | Limited | PayPal ecosystem |
| **RavenPay** | ✗ | ✗ | ✓ Nigeria | Not applicable for this integration |

---

*Sources: [Stripe Apple Pay docs](https://docs.stripe.com/apple-pay) · [Paystack Apple Pay docs](https://paystack.com/docs/payments/apple-pay/) · [Flutterwave Apple Pay docs](https://developer.flutterwave.com/docs/apple-pay) · [RavenPay GitHub](https://github.com/RavenPayAfrica) · [Raven Bank](https://getravenbank.com)*
