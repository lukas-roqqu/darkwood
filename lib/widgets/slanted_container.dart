import 'dart:math' as math;
import 'package:flutter/material.dart';

enum SlantEdge { top, bottom, left, right }

class SlantedContainer extends StatelessWidget {
  const SlantedContainer({
    super.key,
    this.child,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.slantAngle = 6,
    this.slantEdge = SlantEdge.bottom,
  });

  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  /// Per-corner radii
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  /// Angle of the slant in degrees (0 = flat, 45 = steep)
  final double slantAngle;

  /// Which edge gets the slant
  final SlantEdge slantEdge;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SlantClipper(
        topLeftRadius: topLeftRadius,
        topRightRadius: topRightRadius,
        bottomLeftRadius: bottomLeftRadius,
        bottomRightRadius: bottomRightRadius,
        slantAngle: slantAngle,
        slantEdge: slantEdge,
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        color: color,
        child: child,
      ),
    );
  }
}

class _SlantClipper extends CustomClipper<Path> {
  const _SlantClipper({
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
    required this.slantAngle,
    required this.slantEdge,
  });

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double slantAngle;
  final SlantEdge slantEdge;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final hOff = w * math.tan(slantAngle * math.pi / 180);
    final vOff = h * math.tan(slantAngle * math.pi / 180);

    Offset tl, tr, br, bl;

    switch (slantEdge) {
      case SlantEdge.top:
        tl = Offset(0, hOff);
        tr = Offset(w, 0);
        br = Offset(w, h);
        bl = Offset(0, h);
      case SlantEdge.bottom:
        tl = Offset(0, 0);
        tr = Offset(w, 0);
        br = Offset(w, h - hOff);
        bl = Offset(0, h);
      case SlantEdge.left:
        tl = Offset(0, 0);
        tr = Offset(w, 0);
        br = Offset(w, h);
        bl = Offset(0, h - vOff);
      case SlantEdge.right:
        tl = Offset(0, 0);
        tr = Offset(w, vOff);
        br = Offset(w, h);
        bl = Offset(0, h);
    }

    return _buildPath(tl, tr, br, bl);
  }

  Path _buildPath(Offset tl, Offset tr, Offset br, Offset bl) {
    // Returns a point `distance` along the edge from `from` toward `to`
    Offset along(Offset from, Offset to, double distance) {
      final d = to - from;
      final len = d.distance;
      if (len == 0) return from;
      return from + d / len * distance;
    }

    // Anchor points on each edge, offset from each corner by its radius
    final tlOnTop  = along(tl, tr, topLeftRadius);
    final tlOnLeft = along(tl, bl, topLeftRadius);

    final trOnTop   = along(tr, tl, topRightRadius);
    final trOnRight = along(tr, br, topRightRadius);

    final brOnRight  = along(br, tr, bottomRightRadius);
    final brOnBottom = along(br, bl, bottomRightRadius);

    final blOnBottom = along(bl, br, bottomLeftRadius);
    final blOnLeft   = along(bl, tl, bottomLeftRadius);

    final path = Path();

    // Start on top edge just after TL corner
    path.moveTo(tlOnTop.dx, tlOnTop.dy);

    // ── Top edge ──────────────────────────────────────────────────
    path.lineTo(trOnTop.dx, trOnTop.dy);
    _corner(path, tr, trOnRight, topRightRadius);

    // ── Right edge ────────────────────────────────────────────────
    path.lineTo(brOnRight.dx, brOnRight.dy);
    _corner(path, br, brOnBottom, bottomRightRadius);

    // ── Bottom edge ───────────────────────────────────────────────
    path.lineTo(blOnBottom.dx, blOnBottom.dy);
    _corner(path, bl, blOnLeft, bottomLeftRadius);

    // ── Left edge ─────────────────────────────────────────────────
    path.lineTo(tlOnLeft.dx, tlOnLeft.dy);
    _corner(path, tl, tlOnTop, topLeftRadius);

    path.close();
    return path;
  }

  /// Draws corner arc: bezier through [corner] ending at [to].
  /// If radius is 0 we just lineTo the corner — no curve needed.
  void _corner(Path path, Offset corner, Offset to, double radius) {
    if (radius > 0) {
      path.quadraticBezierTo(corner.dx, corner.dy, to.dx, to.dy);
    } else {
      path.lineTo(corner.dx, corner.dy);
    }
  }

  @override
  bool shouldReclip(_SlantClipper old) =>
      old.topLeftRadius != topLeftRadius ||
      old.topRightRadius != topRightRadius ||
      old.bottomLeftRadius != bottomLeftRadius ||
      old.bottomRightRadius != bottomRightRadius ||
      old.slantAngle != slantAngle ||
      old.slantEdge != slantEdge;
}
