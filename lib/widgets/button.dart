import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';
import '../core/colors.dart';
import '../core/constants.dart';

class DarkwoodButton extends StatefulWidget {
  const DarkwoodButton({
    super.key,
    required this.child,
    this.onPressed,
    this.icon,
    this.backgroundColor = DarkwoodColors.black,
    this.foregroundColor = DarkwoodColors.accent,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.margin,
    this.bottomSpacing = 12,
    this.horizontalSpacing = 20,
    this.fontSize,
    this.isEnabled = true,
    this.isLoading = false,
    this.autoLoading = false,
  }) : assert(!(isLoading && autoLoading), 'autoLoading overrides isLoading');

  final Widget child;
  final Function? onPressed;
  final Widget? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double bottomSpacing;
  final double horizontalSpacing;
  final double? fontSize;
  final bool isEnabled;
  final bool isLoading;
  final bool autoLoading;

  @override
  State<DarkwoodButton> createState() => _DarkwoodButtonState();
}

class _DarkwoodButtonState extends State<DarkwoodButton> {
  bool _autoLoading = false;
  bool _pressed = false;

  bool get _busy => widget.isLoading || _autoLoading;

  bool get _active => widget.isEnabled && !_busy && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.margin ?? EdgeInsets.only(bottom: widget.bottomSpacing, left: widget.horizontalSpacing, right: widget.horizontalSpacing),
      child: GestureDetector(
        onTapDown: _active ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _active ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _active ? () => setState(() => _pressed = false) : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: _pressed ? const Duration(milliseconds: 80) : const Duration(milliseconds: 500),
          curve: _pressed ? Curves.easeIn : Sprung.underDamped,
          child: TextButton(
            onPressed: _active
                ? () async {
                    if (widget.autoLoading) setState(() => _autoLoading = true);
                    await widget.onPressed!();
                    if (widget.autoLoading) setState(() => _autoLoading = false);
                  }
                : null,
            style: TextButton.styleFrom(
              minimumSize: Size(widget.width, 24),
              padding: widget.padding,
              textStyle: TextStyle(
                fontSize: widget.fontSize ?? 18,
                fontWeight: FontWeight.w600,
                fontFamily: DarkwoodConstants.fontFamily,
                letterSpacing: 0,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              disabledBackgroundColor: DarkwoodColors.surfaceElevated,
              disabledForegroundColor: DarkwoodColors.textMuted,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Sprung.criticallyDamped,
              clipBehavior: Clip.none,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Sprung.criticallyDamped,
                switchOutCurve: Curves.easeIn,
                child: _busy
                    ? SizedBox(key: const ValueKey(true), height: 26, width: 26, child: CircularProgressIndicator(color: widget.foregroundColor, strokeWidth: 2))
                    : Row(
                        key: const ValueKey(false),
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) widget.icon!,
                          Flexible(
                            child: FittedBox(fit: BoxFit.scaleDown, child: widget.child),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
