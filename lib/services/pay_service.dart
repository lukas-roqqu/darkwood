import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

enum PaymentStatus { idle, processing, success, failed }

enum PaymentProvider { applePay, googlePay }

const String _backendUrl = 'http://192.168.1.171:3000';

class PayService extends GetxService {
  final _http = GetConnect();

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

  PaymentConfiguration get applePayConfig => _appleConfig ??= PaymentConfiguration.fromJsonString(_applePay);

  PaymentConfiguration get googlePayConfig => _googleConfig ??= PaymentConfiguration.fromJsonString(_googlePay);

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

  void onPaymentResult(Map<String, dynamic> result, {VoidCallback? onSuccess}) {
    status.value = PaymentStatus.processing;
    lastResult.value = result;
    lastError.value = null;
    debugPrint('[PayService] Raw token result: $result');
    final isSimulated = result['transactionIdentifier'] == 'Simulated Identifier';
    if (isSimulated) debugPrint('[PayService] ⚠️ Simulated payment — token will be empty. Use a real device for a real token.');
    _submitToBackend(result, onSuccess: onSuccess);
  }

  Future<void> _submitToBackend(Map<String, dynamic> result, {VoidCallback? onSuccess}) async {
    try {
      // Extract the token — empty string on simulator, encrypted string on real device
      final raw = result['token'] as String? ?? '';
      final token = raw.isNotEmpty ? raw : null;

      if (token == null) {
        debugPrint('[PayService] No token — skipping backend call (simulator mode).');
        status.value = PaymentStatus.success;
        onSuccess?.call();
        return;
      }

      final response = await _http.post('$_backendUrl/payments/process', {
        'token': token,
        'provider': result.containsKey('paymentData') ? 'apple_pay' : 'google_pay',
        'amount': (lastResult.value?['amount'] as num?)?.toInt() ?? 0,
        'description': result['description'] as String? ?? 'Darkwood Coffee order',
      });

      if (response.statusCode == 200) {
        debugPrint('[PayService] Payment succeeded — token: $token | response: ${response.body}');
        status.value = PaymentStatus.success;
        onSuccess?.call();
      } else {
        final message = response.body?['message'] ?? 'Payment failed';
        lastError.value = message.toString();
        status.value = PaymentStatus.failed;
        debugPrint('[PayService] Payment rejected — status: ${response.statusCode} | body: ${response.body}');
      }
    } catch (e, stack) {
      lastError.value = e.toString();
      status.value = PaymentStatus.failed;
      debugPrint('[PayService] Backend error: $e\n$stack');
    }
  }

  void onPaymentError(Object? error, {VoidCallback? onError}) {
    if (error is PlatformException && error.code == 'paymentCanceled') {
      status.value = PaymentStatus.idle;
      return;
    }
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
