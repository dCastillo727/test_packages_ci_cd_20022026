import 'dart:math';

import 'package:flutter/material.dart';

class PsychedelicPainter extends CustomPainter {
  /// Factor de deformación: 0 = círculo pequeño normal, a medida que crece
  /// se agranda ligeramente y se deforma de forma irregular.
  final double deformation;

  /// Lista de colores. Con deformation bajo se usa solo el primero;
  /// a medida que crece se intercalan todos.
  final List<Color> colors;

  PsychedelicPainter({
    required this.deformation,
    this.colors = const [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Radio base: círculo pequeño que crece solo un poco con la deformación.
    final minRadius = size.width * 0.12;
    final growthFactor = size.width * 0.12;
    final baseRadius = minRadius + growthFactor * deformation.clamp(0.0, 1.0);

    // --- Construir el path deformado ---
    const int numPoints = 72;
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < numPoints; i++) {
      final angle = (2 * pi * i) / numPoints;

      // Varias ondas superpuestas para irregularidad orgánica.
      double irregularity = 0.0;
      irregularity += sin(angle * 2) * 0.30;
      irregularity += sin(angle * 3 + 1.0) * 0.25;
      irregularity += cos(angle * 5 + 2.0) * 0.18;
      irregularity += sin(angle * 7 + 0.5) * 0.12;

      // Sesgo asimétrico: el lado derecho (cos>0) se estira más que el
      // izquierdo, así se ve orgánico y desigual.
      irregularity += cos(angle) * 0.35;

      // Solo se aplica la irregularidad proporcionalmente a `deformation`.
      final r = baseRadius + baseRadius * irregularity * deformation;

      points.add(
        Offset(
          center.dx + r * cos(angle),
          center.dy + r * sin(angle),
        ),
      );
    }

    // Curvas suaves con interpolación Catmull-Rom → Bézier cúbico.
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < numPoints; i++) {
      final p0 = points[(i - 1 + numPoints) % numPoints];
      final p1 = points[i];
      final p2 = points[(i + 1) % numPoints];
      final p3 = points[(i + 2) % numPoints];

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    path.close();

    // --- Pintura / color ---
    final paint = Paint()..style = PaintingStyle.fill;

    if (colors.isEmpty) {
      paint.color = Colors.white;
      canvas.drawPath(path, paint);
      return;
    }

    // Factor 0→1 que controla la transición de color fijo a gradiente.
    final colorBlend = deformation.clamp(0.0, 1.0);

    if (colorBlend < 0.05 || colors.length == 1) {
      // Deformación muy baja → color sólido (el primero de la lista).
      paint.color = colors.first;
    } else {
      // Interpolar cada color desde el primero hacia su valor real
      // según el factor de deformación. Así la transición es progresiva.
      final gradientColors = colors.map((c) => Color.lerp(colors.first, c, colorBlend)!).toList();

      paint.shader =
          SweepGradient(
            center: Alignment.center,
            colors: [...gradientColors, gradientColors.first],
          ).createShader(
            Rect.fromCircle(center: center, radius: baseRadius * 2),
          );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PsychedelicPainter oldDelegate) {
    return oldDelegate.deformation != deformation || oldDelegate.colors != colors;
  }
}
