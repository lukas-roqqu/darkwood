import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class DarkwoodInkwell extends StatefulWidget {
  const DarkwoodInkwell({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.borderRadius,
    this.decoration,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.pressedScale = 0.94,
    this.duration = const Duration(milliseconds: 120),
    this.behavior = HitTestBehavior.translucent,
    this.isVisible = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;
  final BoxDecoration? decoration;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double pressedScale;
  final Duration duration;
  final HitTestBehavior behavior;
  final bool isVisible;

  @override
  State<DarkwoodInkwell> createState() => _DarkwoodInkwellState();
}

class _DarkwoodInkwellState extends State<DarkwoodInkwell> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.isVisible ? widget.onTap : null,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: !widget.isVisible ? 0 : (_pressed ? widget.pressedScale : 1.0),
        duration: _pressed ? widget.duration : const Duration(milliseconds: 400),
        curve: _pressed ? Curves.easeIn : Sprung.underDamped,
        child: Container(
          padding: widget.padding,
          margin: widget.margin,
          decoration: widget.decoration ??
              BoxDecoration(
                color: widget.color ?? Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              ),
          child: widget.child,
        ),
      ),
    );
  }
}
