import 'package:darkwood/core/extensions.dart';
import 'package:darkwood/views/description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../models/product.dart';
import '../widgets/inkwell.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      final products = controller.filtered;
      final left = [for (var i = 0; i < products.length; i += 2) products[i]];
      final right = [for (var i = 1; i < products.length; i += 2) products[i]];

      return SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 24),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: left.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 0),
                  itemBuilder: (context, i) => _ProductCard(product: left[i], onTap: () => context.push(DescriptionScreen(left[i]))),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 36),
                  itemCount: right.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 0),
                  itemBuilder: (context, i) => _ProductCard(product: right[i], onTap: () => context.push(DescriptionScreen(right[i]))),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DarkwoodInkwell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: DarkwoodColors.background, borderRadius: BorderRadius.circular(DarkwoodConstants.radiusSM)),
            padding: const EdgeInsets.only(top: 100, left: 12, right: 12, bottom: 12),
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: context.titleMedium?.copyWith(fontSize: 17), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  product.sizesLabel,
                  style: context.labelMedium?.copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text('£${product.startingPrice.toStringAsFixed(2)}', style: context.labelLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),
          Positioned.fill(top: -80, child: Image.asset(product.imagePath, fit: BoxFit.fitWidth)),
        ],
      ),
    );
  }
}
