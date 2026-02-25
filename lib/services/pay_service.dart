import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

enum PaymentStatus { idle, processing, success, failed }

enum PaymentProvider { applePay, googlePay }

class PayService extends GetxService {
  // ── State ──────────────────────────────────────────────────────
  final status = PaymentStatus.idle.obs;
  final lastResult = Rxn<Map<String, dynamic>>();
  final lastError = RxnString();

  // ── Configs ────────────────────────────────────────────────────
  // Loaded once at init and cached
  PaymentConfiguration? _appleConfig;
  PaymentConfiguration? _googleConfig;

  // ── Apple Pay config ──────────────────────────────────────────
  static const String _applePay = '''{
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.lukasio.darkwood",
      "displayName": "Darkwood Coffee",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": "GB",
      "currencyCode": "GBP",
      "requiredBillingContactFields": ["postalAddress", "name"],
      "requiredShippingContactFields": ["postalAddress", "name", "emailAddress"]
    }
  }''';

  // ── Google Pay config ─────────────────────────────────────────
  static const String _googlePay = '''{
    "provider": "google_pay",
    "data": {
      "environment": "TEST",
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "merchantInfo": {
        "merchantName": "Darkwood Coffee"
      },
      "allowedPaymentMethods": [
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "example",
              "gatewayMerchantId": "exampleGatewayMerchantId"
            }
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD", "AMEX"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {
              "format": "FULL"
            }
          }
        }
      ],
      "transactionInfo": {
        "countryCode": "GB",
        "currencyCode": "GBP"
      }
    }
  }''';

  // ── Init ───────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _appleConfig = PaymentConfiguration.fromJsonString(_applePay);
    _googleConfig = PaymentConfiguration.fromJsonString(_googlePay);
  }

  // ── Getters ────────────────────────────────────────────────────

  PaymentConfiguration get applePayConfig =>
      _appleConfig ??= PaymentConfiguration.fromJsonString(_applePay);

  PaymentConfiguration get googlePayConfig =>
      _googleConfig ??= PaymentConfiguration.fromJsonString(_googlePay);

  bool get isIdle => status.value == PaymentStatus.idle;
  bool get isProcessing => status.value == PaymentStatus.processing;

  // ── Payment items helper ───────────────────────────────────────

  List<PaymentItem> buildPaymentItems(List<Map<String, dynamic>> rawItems) {
    return rawItems.map((item) {
      final isTotal = item['type'] == 'total';
      return PaymentItem(
        label: item['label'] as String,
        amount: item['amount'] as String,
        type: isTotal ? PaymentItemType.total : PaymentItemType.item,
        status: PaymentItemStatus.final_price,
      );
    }).toList();
  }

  // ── Result handling ────────────────────────────────────────────

  void onPaymentResult(
    Map<String, dynamic> result, {
    VoidCallback? onSuccess,
  }) {
    status.value = PaymentStatus.processing;
    lastResult.value = result;
    lastError.value = null;

    // TODO: send `result` (payment token) to your backend here
    debugPrint('[PayService] Payment token received: $result');

    status.value = PaymentStatus.success;
    onSuccess?.call();
  }

  void onPaymentError(
    Object? error, {
    VoidCallback? onError,
  }) {
    lastError.value = error?.toString() ?? 'Payment failed';
    status.value = PaymentStatus.failed;
    debugPrint('[PayService] Payment error: $error');
    onError?.call();
  }

  void reset() {
    status.value = PaymentStatus.idle;
    lastResult.value = null;
    lastError.value = null;
  }
}
