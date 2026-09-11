import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Bespoke CustomPainter for the faceted Onyx crystal with glowing emerald ribbon.
/// 100% native vector rendering with zero asset dependencies (crash-proof).
class OnyxGemstonePainter extends CustomPainter {
  const OnyxGemstonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Geometric vertices
    final top = Offset(w * 0.50, h * 0.12);
    final bottom = Offset(w * 0.50, h * 0.88);
    final left = Offset(w * 0.22, h * 0.50);
    final right = Offset(w * 0.78, h * 0.50);
    final center = Offset(w * 0.50, h * 0.54);

    // 1. Facet Left Upper: Obsidian slate
    final pathLeftUpper = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final paintLeftUpper = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF334155), Color(0xFF0F172A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(pathLeftUpper, paintLeftUpper);

    // 2. Facet Right Upper: Radiant neon mint & emerald
    final pathRightUpper = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final paintRightUpper = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00D589), Color(0xFF059669)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(pathRightUpper, paintRightUpper);

    // 3. Facet Left Lower: Deep midnight obsidian
    final pathLeftLower = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final paintLeftLower = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF090E17), Color(0xFF1E293B)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(pathLeftLower, paintLeftLower);

    // 4. Facet Right Lower: Rich emerald green
    final pathRightLower = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final paintRightLower = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF064E3B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(pathRightLower, paintRightLower);

    // 5. Specular facet bevel edges
    final edgePaint = Paint()
      ..color = const Color(0x40FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.03).clamp(0.8, 2.0);
    canvas.drawPath(pathLeftUpper, edgePaint);
    canvas.drawPath(pathRightUpper, edgePaint);
    canvas.drawPath(pathLeftLower, edgePaint);
    canvas.drawPath(pathRightLower, edgePaint);

    // 6. Glowing ascending neon ribbon vector
    final ribbonPath = Path()
      ..moveTo(w * 0.12, h * 0.68)
      ..cubicTo(w * 0.20, h * 0.38, w * 0.52, h * 0.34, w * 0.88, h * 0.40);

    if (w >= 28) {
      final ribbonGlow = Paint()
        ..color = const Color(0x5500D589)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (w * 0.14).clamp(2.0, 7.0)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawPath(ribbonPath, ribbonGlow);
    }

    final ribbonCore = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00D589), Color(0xFF34D399)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (w * 0.08).clamp(1.5, 4.5);
    canvas.drawPath(ribbonPath, ribbonCore);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Modern luxury brand mark for ONYX Personal Finance.
class OnyxLogo extends StatelessWidget {
  const OnyxLogo({
    super.key,
    this.size = 52,
    this.showText = false,
    this.subtitle,
    this.expanded = true,
  });

  final double size;
  final bool showText;
  final String? subtitle;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular((size * 0.28).clamp(4.0, 20.0));
    final iconBadge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.midnight,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.emerald.withValues(alpha: 0.35),
          width: (size * 0.03).clamp(0.8, 1.8),
        ),
        boxShadow: size >= 32
            ? [
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.20),
                  blurRadius: size * 0.30,
                  offset: Offset(0, size * 0.08),
                ),
                BoxShadow(
                  color: AppColors.midnight.withValues(alpha: 0.40),
                  blurRadius: size * 0.20,
                  offset: Offset(0, size * 0.12),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CustomPaint(
          size: Size(size, size),
          painter: const OnyxGemstonePainter(),
        ),
      ),
    );

    if (!showText) return iconBadge;

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ONYX',
              style: GoogleFonts.plusJakartaSans(
                fontSize: (size * 0.40).clamp(14.0, 26.0),
                fontWeight: FontWeight.w900,
                color: AppColors.midnight,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.mint,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        Text(
          subtitle ?? 'Wealth Intelligence',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: (size * 0.22).clamp(10.0, 13.0),
            color: AppColors.emerald,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        iconBadge,
        SizedBox(width: size * 0.26),
        if (expanded) Expanded(child: textContent) else textContent,
      ],
    );
  }
}
