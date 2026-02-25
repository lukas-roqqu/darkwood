import 'package:darkwood/core/colors.dart';
import 'package:darkwood/views/products_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../services/pay_service.dart';
import '../widgets/app_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(PayService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: DarkwoodColors.paleAccent,
      appBar: DarkwoodAppBar(title: Text('Espresso')),
      body: ProductsListView(),
    );
  }
}
