import 'dart:io';

import 'package:darkwood/core/colors.dart';
import 'package:darkwood/core/constants.dart';
import 'package:darkwood/core/extensions.dart';
import 'package:darkwood/models/product.dart';
import 'package:darkwood/models/review.dart';
import 'package:darkwood/services/pay_service.dart';
import 'package:darkwood/widgets/app_bar.dart';
import 'package:darkwood/widgets/inkwell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen(this.product, {super.key});

  final Product product;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  late ProductVariant _selectedVariant;
  late final PayService payService;
  int _quantity = 1;

  Product get product => widget.product;

  List<String> get _sizes => product.variants.map((v) => v.size).toSet().toList();

  @override
  void initState() {
    super.initState();
    payService = Get.find<PayService>();
    _selectedVariant = product.defaultVariant;
    _diagnosePayAvailability();
  }

  void _diagnosePayAvailability() {
    if (!Platform.isIOS) return;
    Pay({PayProvider.apple_pay: payService.applePayConfig})
        .userCanPay(PayProvider.apple_pay)
        .then((can) => debugPrint('[Pay] canMakePayments → $can'))
        .catchError((e) => debugPrint('[Pay] canMakePayments error → $e'));
  }

  void _selectSize(String size) {
    final match = product.variants.firstWhereOrNull((v) => v.size == size && v.grind == _selectedVariant.grind);
    setState(() => _selectedVariant = match ?? product.variants.firstWhere((v) => v.size == size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkwoodColors.background,
      extendBodyBehindAppBar: true,
      appBar: DarkwoodAppBar(color: DarkwoodColors.background),
      bottomNavigationBar: _BottomBar(
        paymentItems: payService.buildPaymentItems([
          {
            'label': '${product.name} · ${_selectedVariant.label}',
            'amount': (_selectedVariant.price * _quantity).toStringAsFixed(2),
            'type': 'item',
          },
          {'label': 'Total', 'amount': (_selectedVariant.price * _quantity).toStringAsFixed(2), 'type': 'total'},
        ]),
        onSuccess: context.pop,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentGeometry.center,
                child: Image.asset(product.imagePath, height: 300, fit: BoxFit.contain),
              ),
              Text(product.tagline, style: context.bodyMedium),
              SizedBox(height: 4),
              Text(product.name, style: context.headlineLarge),
              SizedBox(height: 12),

              if (product.reviewCount > 0) ...[_StarRating(rating: product.avgRating, count: product.reviewCount), SizedBox(height: 20)],

              _SizeSelector(sizes: _sizes, selected: _selectedVariant.size, onSelect: _selectSize),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('£${_selectedVariant.price.toStringAsFixed(2)}', style: context.displayMedium),
                  _QuantitySelector(
                    quantity: _quantity,
                    onDecrement: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                    onIncrement: () => setState(() => _quantity++),
                  ),
                ],
              ),

              Divider(height: 32),

              Text('Description', style: context.titleLarge),
              SizedBox(height: 8),
              Text(product.description, style: context.bodyMedium),

              if (product.reviews.isNotEmpty) ...[
                Divider(height: 48),
                Text('Reviews', style: context.titleLarge),
                const SizedBox(height: 12),
                ...product.reviews.map((r) => _ReviewTile(review: r)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Size selector ────────────────────────────────────────────────────────────

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.sizes, required this.selected, required this.onSelect});

  final List<String> sizes;
  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: DarkwoodColors.paleAccent, borderRadius: BorderRadius.circular(DarkwoodConstants.radiusFull)),
      child: Row(
        children: sizes.map((size) {
          final isSelected = size == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(size),
              child: AnimatedContainer(
                duration: DarkwoodConstants.animFast,
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? DarkwoodColors.accent : DarkwoodColors.accent.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(DarkwoodConstants.radiusFull),
                ),
                child: Text(
                  size,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DarkwoodConstants.fontFamily,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? DarkwoodColors.black : DarkwoodColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.25;

    return Row(
      children: [
        ...List.generate(full, (_) => const Icon(Icons.star_rounded, size: 18, color: DarkwoodColors.accent)),
        if (hasHalf) const Icon(Icons.star_half_rounded, size: 18, color: DarkwoodColors.accent),
        ...List.generate(
          5 - full - (hasHalf ? 1 : 0),
          (_) => const Icon(Icons.star_outline_rounded, size: 18, color: DarkwoodColors.accent),
        ),
        const SizedBox(width: 6),
        Text('${rating.toStringAsFixed(1)} · $count reviews', style: tt.bodySmall),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.quantity, required this.onDecrement, required this.onIncrement});

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        border: Border.all(color: Colors.grey, width: 0.3),
      ),
      child: Row(
        children: [
          DarkwoodInkwell(
            onTap: onDecrement,
            color: DarkwoodColors.surface,
            borderRadius: DarkwoodConstants.radiusFull,
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.remove_rounded, size: 18, color: DarkwoodColors.black),
          ),
          Text('$quantity', style: tt.titleLarge, textAlign: TextAlign.center),
          DarkwoodInkwell(
            onTap: onIncrement,
            color: DarkwoodColors.surface,
            borderRadius: DarkwoodConstants.radiusFull,
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.add_rounded, size: 18, color: DarkwoodColors.black),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final full = review.rating.floor();
    final hasHalf = (review.rating - full) >= 0.25;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(review.reviewer, style: tt.titleMedium)),
              ...List.generate(full, (_) => const Icon(Icons.star_rounded, size: 14, color: DarkwoodColors.accent)),
              if (hasHalf) const Icon(Icons.star_half_rounded, size: 14, color: DarkwoodColors.accent),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.body, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.paymentItems, required this.onSuccess});

  final List<PaymentItem> paymentItems;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    final payService = Get.find<PayService>();

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: DarkwoodColors.background, blurRadius: 16, offset: Offset(0, -8), spreadRadius: 8)],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SafeArea(
        top: false,
        child: Platform.isIOS
            ? ApplePayButton(
                paymentConfiguration: payService.applePayConfig,
                paymentItems: paymentItems,
                height: 54,
                cornerRadius: 54 / 2,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                onPaymentResult: (result) => payService.onPaymentResult(result, onSuccess: onSuccess),
                onError: payService.onPaymentError,
              )
            : GooglePayButton(
                paymentConfiguration: payService.googlePayConfig,
                paymentItems: paymentItems,
                height: 54,
                theme: GooglePayButtonTheme.dark,
                type: GooglePayButtonType.buy,
                onPaymentResult: (result) => payService.onPaymentResult(result, onSuccess: onSuccess),
                onError: payService.onPaymentError,
              ),
      ),
    );
  }
}
