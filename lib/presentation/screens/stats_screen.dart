import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── CAPA 1: FONDO VAPOROSO GLOBAL ──────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F0F1E),
                    Color(0xFF0B0E14),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            top: -100,
            left: -100,
            child: _VaporSphere(color: const Color(0xFF00F2FF).withOpacity(0.1), size: 500), // Cian
          ),
          Positioned(
            bottom: 50,
            right: -100,
            child: _VaporSphere(color: const Color(0xFF8E2DE2).withOpacity(0.1), size: 600), // Violeta
          ),

          // ── CAPA 2: CONTENIDO ──────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  
                  // 1. HEADER
                  Text(
                    'Tus Estadísticas',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 2. TARJETAS DE DATOS (Glassmorphism)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          'Tiempo Total',
                          '42h 15m',
                          const Color(0xFF00F2FF),
                          Icons.access_time_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatsCard(
                          'Reproducciones',
                          '1,284',
                          const Color(0xFF8E2DE2),
                          Icons.play_circle_outline_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 3. GRÁFICO LINEAL DE NEÓN
                  Text(
                    'Actividad Semanal',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // El Gráfico
                  Container(
                    height: 220,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
                    ),
                    child: CustomPaint(
                      painter: _NeonChartPainter(),
                      child: Container(),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Labels Semanales
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                        .map((day) => Text(
                              day,
                              style: GoogleFonts.poppins(
                                color: Colors.white24,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String label, String value, Color glowColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: glowColor, size: 24),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width, size.height * 0.3),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      path.quadraticBezierTo(
        p0.dx + (p1.dx - p0.dx) / 2, p0.dy,
        p1.dx, p1.dy,
      );
    }

    // 1. Fill Gradient (Aura inferior)
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF4D00).withOpacity(0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, fillPaint);

    // 2. Neon Line Glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFF4D00).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);

    // 3. Main Neon Line
    final linePaint = Paint()
      ..color = const Color(0xFFFF4D00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VaporSphere extends StatelessWidget {
  final Color color;
  final double size;
  const _VaporSphere({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
