import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/colors.dart';
import '../core/constants.dart';

class DarkwoodAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DarkwoodAppBar({super.key, this.title, this.leading, this.actions, this.bottom});

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: DarkwoodColors.paleAccent, blurRadius: 16, offset: Offset(0, -8), spreadRadius: 8)],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: DarkwoodColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
        titleTextStyle: const TextStyle(
          fontFamily: DarkwoodConstants.fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: DarkwoodColors.black,
        ),
        title: title,
        leading: leading,
        actions: actions,
        bottom: bottom,
      ),
    );
  }
}
