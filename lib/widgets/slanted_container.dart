import 'dart:math' as math;
import 'package:darkwood/core/colors.dart';
import 'package:flutter/material.dart';

enum SlantEdge { top, bottom, left, right }

class SlantedContainer extends StatelessWidget {
  const SlantedContainer({
    super.key,
    this.child,
    this.color,
    this.width,
    this.height,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 32,
    this.bottomRightRadius = 32,
    this.slantAngle = 6,
    this.slantEdge = SlantEdge.bottom,
    this.coverage = 0.6,
  });

  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;

  /// Per-corner radii
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  /// Angle of the slant in degrees (0 = flat, 45 = steep)
  final double slantAngle;

  /// Which edge gets the slant
  final SlantEdge slantEdge;

  /// How much of the widget the background fills (0.0–1.0). Default 0.6.
  /// e.g. SlantEdge.bottom + coverage 0.6 → bg fills top 60% with a
  /// slanted bottom edge; child sits unclipped over the full space.
  final double coverage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Slanted background ──────────────────────────────────
          Positioned.fill(
            child: ClipPath(
              clipper: _SlantClipper(
                topLeftRadius: topLeftRadius,
                topRightRadius: topRightRadius,
                bottomLeftRadius: bottomLeftRadius,
                bottomRightRadius: bottomRightRadius,
                slantAngle: slantAngle,
                slantEdge: slantEdge,
                coverage: coverage,
              ),
              child: ColoredBox(color: color ?? DarkwoodColors.paleAccent),
            ),
          ),
          // ── Child (unclipped, full bounds) ──────────────────────
          ?child,
        ],
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
    required this.coverage,
  });

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double slantAngle;
  final SlantEdge slantEdge;
  final double coverage;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final hOff = w * math.tan(slantAngle * math.pi / 180);
    final vOff = h * math.tan(slantAngle * math.pi / 180);
    final c = coverage.clamp(0.0, 1.0);

    Offset tl, tr, br, bl;

    switch (slantEdge) {
      // bg fills TOP c% — slanted bottom edge
      case SlantEdge.bottom:
        tl = Offset(0, 0);
        tr = Offset(w, 0);
        br = Offset(w, c * h - hOff);
        bl = Offset(0, c * h);
      // bg fills BOTTOM c% — slanted top edge
      case SlantEdge.top:
        tl = Offset(0, (1 - c) * h + hOff);
        tr = Offset(w, (1 - c) * h);
        br = Offset(w, h);
        bl = Offset(0, h);
      // bg fills LEFT c% — slanted right edge
      case SlantEdge.right:
        tl = Offset(0, 0);
        tr = Offset(c * w, 0);
        br = Offset(c * w - vOff, h);
        bl = Offset(0, h);
      // bg fills RIGHT c% — slanted left edge
      case SlantEdge.left:
        tl = Offset((1 - c) * w + vOff, 0);
        tr = Offset(w, 0);
        br = Offset(w, h);
        bl = Offset((1 - c) * w, h);
    }

    return _buildPath(tl, tr, br, bl);
  }

  Path _buildPath(Offset tl, Offset tr, Offset br, Offset bl) {
    Offset along(Offset from, Offset to, double distance) {
      final d = to - from;
      final len = d.distance;
      if (len == 0) return from;
      return from + d / len * distance;
    }

    final tlOnTop = along(tl, tr, topLeftRadius);
    final tlOnLeft = along(tl, bl, topLeftRadius);
    final trOnTop = along(tr, tl, topRightRadius);
    final trOnRight = along(tr, br, topRightRadius);
    final brOnRight = along(br, tr, bottomRightRadius);
    final brOnBottom = along(br, bl, bottomRightRadius);
    final blOnBottom = along(bl, br, bottomLeftRadius);
    final blOnLeft = along(bl, tl, bottomLeftRadius);

    final path = Path();
    path.moveTo(tlOnTop.dx, tlOnTop.dy);

    path.lineTo(trOnTop.dx, trOnTop.dy);
    _corner(path, tr, trOnRight, topRightRadius);

    path.lineTo(brOnRight.dx, brOnRight.dy);
    _corner(path, br, brOnBottom, bottomRightRadius);

    path.lineTo(blOnBottom.dx, blOnBottom.dy);
    _corner(path, bl, blOnLeft, bottomLeftRadius);

    path.lineTo(tlOnLeft.dx, tlOnLeft.dy);
    _corner(path, tl, tlOnTop, topLeftRadius);

    path.close();
    return path;
  }

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
      old.slantEdge != slantEdge ||
      old.coverage != coverage;
}
