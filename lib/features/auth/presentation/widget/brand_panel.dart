// ==========================================================
// Right Hero
// ==========================================================

import 'package:flutter/material.dart';

import '../../../../core/common/logo.dart';
import '../../../../core/config/business_config.dart';

class BrandPanel extends StatelessWidget {
  const BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LoginColors.navy,
      child: Stack(
        children: [
          // Background grid
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          Padding(
            padding: const EdgeInsets.fromLTRB(65, 35, 55, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const Align(alignment: Alignment.topRight, child: BrandLogo()),

                const Spacer(),

                Align(
                  alignment: .centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إدارة أذكى. تعليم أفضل',
                          style: TextStyle(
                            color: Color(0xFF6ED5CF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 25),

                        Text(
                          'كل تفاصيل أكاديميتك',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFFFFFBF1),
                            fontSize: 42,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),

                        Text(
                          'في مكان واحد.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: LoginColors.coral,
                            fontSize: 42,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),

                        SizedBox(height: 24),

                        Text(
                          'مساحة تشغيل مصممة للمديرين والمدرسين في مصر، '
                          'من أول حضور إلى آخر إيصال.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFFE9EEE9),
                            fontSize: 13,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                const Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'منصة إدارة الأكاديميات التعليمية',
                      style: TextStyle(color: Color(0xFF87BBB8), fontSize: 9),
                    ),
                    Text(
                      BusinessConfig.adress,
                      style: TextStyle(color: Color(0xFF87BBB8), fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Background grid
// ==========================================================

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .018)
      ..strokeWidth = 1;

    const spacing = 42.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
