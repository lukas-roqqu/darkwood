import 'dart:io';

import 'package:darkwood/core/colors.dart';
import 'package:darkwood/core/constants.dart';
import 'package:darkwood/core/extensions.dart';
import 'package:darkwood/models/product.dart';
import 'package:darkwood/models/review.dart';
import 'package:darkwood/services/pay_service.dart';
import 'package:darkwood/widgets/inkwell.dart';
import 'package:darkwood/widgets/slanted_container.dart';
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
  }

  void _selectSize(String size) {
    final match = product.variants.firstWhereOrNull((v) => v.size == size && v.grind == _selectedVariant.grind);
    setState(() => _selectedVariant = match ?? product.variants.firstWhere((v) => v.size == size));
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: DarkwoodColors.background,
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
      body: SlantedContainer(
        coverage: 0.5,
        child: Column(
          children: [
            // ── Image area ───────────────────────────────────────
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DarkwoodInkwell(
                        onTap: context.pop,
                        borderRadius: DarkwoodConstants.radiusFull,
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.arrow_back_rounded, color: DarkwoodColors.black, size: 22),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: Image.asset(product.imagePath, height: 220, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),

            // ── Content card ─────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: DarkwoodColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(DarkwoodConstants.radiusXL)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline + name
                      Text(product.tagline, style: tt.bodyMedium),
                      const SizedBox(height: 4),
                      Text(product.name, style: tt.headlineLarge),
                      const SizedBox(height: 12),

                      // Star rating
                      if (product.reviewCount > 0) ...[
                        _StarRating(rating: product.avgRating, count: product.reviewCount),
                        const SizedBox(height: 20),
                      ],

                      // Size selector
                      _SizeSelector(sizes: _sizes, selected: _selectedVariant.size, onSelect: _selectSize),
                      const SizedBox(height: 24),

                      // Price + quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('£${_selectedVariant.price.toStringAsFixed(2)}', style: tt.displayMedium),
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
                      const SizedBox(height: 24),

                      const Divider(),
                      const SizedBox(height: 16),

                      // Description
                      Text('Description', style: tt.titleLarge),
                      const SizedBox(height: 8),
                      Text(product.description, style: tt.bodyMedium),

                      // Reviews
                      if (product.reviews.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text('Reviews', style: tt.titleLarge),
                        const SizedBox(height: 12),
                        ...product.reviews.map((r) => _ReviewTile(review: r)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: DarkwoodColors.surface, borderRadius: BorderRadius.circular(DarkwoodConstants.radiusFull)),
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
                  color: isSelected ? DarkwoodColors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(DarkwoodConstants.radiusFull),
                ),
                child: Text(
                  size,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DarkwoodConstants.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? DarkwoodColors.accent : DarkwoodColors.textSecondary,
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

// ── Star rating ──────────────────────────────────────────────────────────────

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

// ── Quantity selector ────────────────────────────────────────────────────────

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.quantity, required this.onDecrement, required this.onIncrement});

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        DarkwoodInkwell(
          onTap: onDecrement,
          color: DarkwoodColors.surface,
          borderRadius: DarkwoodConstants.radiusFull,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.remove_rounded, size: 18, color: DarkwoodColors.black),
        ),
        SizedBox(
          width: 40,
          child: Text('$quantity', style: tt.titleLarge, textAlign: TextAlign.center),
        ),
        DarkwoodInkwell(
          onTap: onIncrement,
          color: DarkwoodColors.surface,
          borderRadius: DarkwoodConstants.radiusFull,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.add_rounded, size: 18, color: DarkwoodColors.black),
        ),
      ],
    );
  }
}

// ── Review tile ──────────────────────────────────────────────────────────────

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final full = review.rating.floor();
    final hasHalf = (review.rating - full) >= 0.25;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
          Text(review.body, style: tt.bodySmall),
        ],
      ),
    );
  }
}

// ── Bottom bar ───────────────────────────────────────────────────────────────

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
