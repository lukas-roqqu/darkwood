import 'package:darkwood/core/assets.dart';
import 'package:darkwood/core/colors.dart';
import 'package:darkwood/widgets/button.dart';
import 'package:darkwood/widgets/inkwell.dart';
import 'package:darkwood/widgets/slanted_container.dart';
import 'package:flutter/material.dart';
import '../core/extensions.dart';
import 'products.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlantedContainer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(DarkwoodAssets.logo, width: 150),
                Expanded(child: Image.asset(DarkwoodAssets.mascot, fit: BoxFit.contain)),
                Text('Become a member', style: context.headlineLarge, textAlign: TextAlign.center),
                SizedBox(height: 8),
                Text("Enjoy the benefits of Darkwood's coffee membership.", style: context.bodyMedium, textAlign: TextAlign.center),
                SizedBox(height: 32),
                DarkwoodButton(onPressed: () => context.push(ProductsScreen()), horizontalSpacing: 0, child: Text('Join the family')),
                DarkwoodInkwell(
                  onTap: () => context.push(ProductsScreen()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Already a member? ', style: context.bodyMedium),
                      Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.w700, color: DarkwoodColors.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
