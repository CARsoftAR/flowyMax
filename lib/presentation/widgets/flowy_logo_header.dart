import 'dart:ui';
import 'package:flutter/material.dart';

class FlowyLogoHeader extends StatelessWidget {
  const FlowyLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Exact 'F' Intertwined Play Icon
        CustomPaint(
          size: const Size(60, 60),
          painter: _ExactFPlayPainter(),
        ),
        const SizedBox(height: 12),
        // Flowy Text (Case Sensitive)
        const Text(
          'Flowy',
          style: TextStyle(
            color: Color(0xFFE0F7FA), // Light cyan/white
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        // Precise Lower Waves
        CustomPaint(
          size: const Size(180, 20),
          painter: _PreciseWavePainter(),
        ),
      ],
    );
  }
}

class _ExactFPlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB39DDB), // Lila suave
          Color(0xFFE0F7FA), // Cian/Blanco
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // El trazo de la 'F' entrelazada formando el Play
    // Iniciamos en la parte superior del triángulo
    path.moveTo(size.width * 0.35, size.height * 0.15);
    
    // Bajamos para formar la columna de la F con un loop suave
    path.lineTo(size.width * 0.35, size.height * 0.45);
    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.55,
      size.width * 0.45, size.height * 0.55,
    );
    path.lineTo(size.width * 0.25, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.15, size.height * 0.55,
      size.width * 0.15, size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.15, size.height * 0.85,
      size.width * 0.35, size.height * 0.85,
    );
    
    // Subimos y cerramos el triángulo de Play
    path.lineTo(size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width * 0.35, size.height * 0.15);
    
    // El trazo superior de la F
    path.moveTo(size.width * 0.25, size.height * 0.3);
    path.lineTo(size.width * 0.55, size.height * 0.3);

    canvas.drawPath(path, paint);

    // Pequeño triángulo sólido de play interno (como en la imagen)
    final innerPaint = Paint()
      ..color = const Color(0xFFE0F7FA).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final innerPath = Path();
    innerPath.moveTo(size.width * 0.62, size.height * 0.46);
    innerPath.lineTo(size.width * 0.72, size.height * 0.5);
    innerPath.lineTo(size.width * 0.62, size.height * 0.54);
    innerPath.close();
    
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PreciseWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFB39DDB).withOpacity(0.4),
          const Color(0xFFE0F7FA).withOpacity(0.6),
          const Color(0xFFB39DDB).withOpacity(0.4),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.8);
    path1.cubicTo(
      size.width * 0.25, size.height * 0.1,
      size.width * 0.75, size.height * 1.5,
      size.width, size.height * 0.5,
    );
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.cubicTo(
      size.width * 0.3, size.height * 1.2,
      size.width * 0.6, size.height * -0.2,
      size.width, size.height * 0.8,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
