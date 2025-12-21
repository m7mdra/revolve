part of '../revolve.dart';

/// Custom painter for drawing the orbit path
class _OrbitPathPainter extends CustomPainter {
  _OrbitPathPainter({required this.radius, required this.decoration});

  final double radius;
  final OrbitDecoration decoration;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = decoration.color!.withValues(alpha: decoration.opacity)
      ..strokeWidth = decoration.width
      ..style = PaintingStyle.stroke;

    if (decoration.style == OrbitStyle.solid) {
      canvas.drawCircle(center, radius, paint);
    } else {
      _drawDashedCircle(
        canvas,
        center,
        radius,
        paint,
        decoration.effectiveDashPattern,
      );
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    List<double> dashPattern,
  ) {
    if (dashPattern.isEmpty) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    final circumference = 2 * math.pi * radius;

    double distance = 0;
    int patternIndex = 0;
    bool drawing = true;

    while (distance < circumference) {
      final dashLength = dashPattern[patternIndex % dashPattern.length];
      final angle = distance / radius;

      if (drawing) {
        final startAngle = angle;
        final endAngle = math.min(angle + dashLength / radius, 2 * math.pi);

        final arcPath = Path();
        arcPath.addArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          endAngle - startAngle,
        );
        canvas.drawPath(arcPath, paint);
      }

      distance += dashLength;
      patternIndex++;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_OrbitPathPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.decoration != decoration;
  }
}
