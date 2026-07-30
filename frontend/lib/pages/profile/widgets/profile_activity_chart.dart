import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

class ProfileActivityChart extends StatelessWidget {
  const ProfileActivityChart({super.key});

  static const _data = [
    0.15, 0.25, 0.35, 0.55, 0.45, 0.7, 0.6, 0.85, 0.75, 0.9, 0.8, 0.95,
  ];

  static const _labels = [
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        painter: _ActivityChartPainter(data: _data, labels: _labels),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ActivityChartPainter extends CustomPainter {
  _ActivityChartPainter({
    required this.data,
    required this.labels,
  });

  final List<double> data;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const paddingLeft = 8.0;
    const paddingRight = 8.0;
    const paddingTop = 12.0;
    const paddingBottom = 28.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    final gridPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = paddingTop + chartHeight * i / 4;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = paddingLeft + chartWidth * i / (data.length - 1);
      final y = paddingTop + chartHeight * (1 - data[i]);
      points.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = AppColors.textLight
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final controlX = (prev.dx + current.dx) / 2;
      path.cubicTo(
        controlX,
        prev.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.textLight;
    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }

    final textStyle = TextStyle(
      color: AppColors.textMuted.withValues(alpha: 0.8),
      fontSize: 10,
    );

    for (var i = 0; i < labels.length; i++) {
      final x = paddingLeft + chartWidth * i / (labels.length - 1);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, size.height - paddingBottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityChartPainter oldDelegate) {
    return !listEquals(data, oldDelegate.data);
  }

  bool listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
