import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/player_bloc.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        final song = state.currentSong;
        if (song == null) return const Scaffold(backgroundColor: Color(0xFF0F0F1E));

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // ── CAPA 1: FONDO VAPOROSO EXTREMO ─────────────────────────────
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: song.coverUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                    ),
                  ),
                ),
              ),

              // ── CAPA 2: CONTENIDO ──────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Top Bar Minimal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 36),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'PLAYING NOW',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),

                      const Spacer(flex: 3),

                      // Arte del Álbum (Hero con Glow Dinámico)
                      Center(
                        child: Hero(
                          tag: 'album_art',
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.78,
                            height: MediaQuery.of(context).size.width * 0.78,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF4D00).withOpacity(0.3),
                                  blurRadius: 70,
                                  spreadRadius: -10,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: CachedNetworkImage(
                                imageUrl: song.coverUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Info
                      Text(
                        song.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        song.artist,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 50),

                      // ── BARRA DE PROGRESO "REPLICA 3D JEWEL" ───────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFFFF4D00),
                                inactiveTrackColor: Colors.white.withOpacity(0.1),
                                trackHeight: 12.0, // Más grueso para el efecto cápsula
                                trackShape: const _ReplicaSliderTrackShape(),
                                thumbShape: const _ReplicaSliderThumbShape(thumbRadius: 18),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                              ),
                              child: Slider(
                                value: state.position.inSeconds.toDouble(),
                                max: state.duration.inSeconds > 0 
                                    ? state.duration.inSeconds.toDouble() 
                                    : 100,
                                onChanged: (v) {
                                  context.read<PlayerBloc>().add(Seek(Duration(seconds: v.toInt())));
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(state.position),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(state.duration),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ── PANEL DE CRISTAL ESMERILADO ────────────────────────
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(44),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(44),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                  width: 0.6,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.shuffle_rounded, color: Colors.white24, size: 22),
                                  const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                                  
                                  // Botón Play
                                  GestureDetector(
                                    onTap: () => context.read<PlayerBloc>().add(TogglePause()),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFF4D00),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF4D00).withOpacity(0.4),
                                            blurRadius: 20,
                                            offset: const Offset(0, 6),
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 44,
                                      ),
                                    ),
                                  ),

                                  const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                                  const Icon(Icons.repeat_rounded, color: Colors.white24, size: 22),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

// ── REPLICA SHAPES (image_f5c908.png) ─────────────────────────────────────────

class _ReplicaSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const _ReplicaSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    // 1. Tubo de Vidrio Exterior (Inactive Track)
    final Paint glassPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    final Paint glassBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(RRect.fromRectAndRadius(trackRect, trackRadius), glassPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(trackRect, trackRadius), glassBorderPaint);

    // 2. Líquido Neón Interior (Active Track)
    final double activeWidth = thumbCenter.dx - trackRect.left;
    if (activeWidth > 0) {
      final Rect activeRect = Rect.fromLTWH(
        trackRect.left + 4, 
        trackRect.top + 4, 
        activeWidth - 4, 
        trackRect.height - 8
      );
      final Radius activeRadius = Radius.circular(activeRect.height / 2);

      // Glow de Neón
      final Paint neonGlow = Paint()
        ..color = const Color(0xFFFF4D00).withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawRRect(RRect.fromRectAndRadius(activeRect.inflate(2), activeRadius), neonGlow);

      // Core de Neón
      final Paint neonCore = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF4D00), Color(0xFFFF9D00)],
        ).createShader(activeRect);
      canvas.drawRRect(RRect.fromRectAndRadius(activeRect, activeRadius), neonCore);
    }
  }
}

class _ReplicaSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;
  const _ReplicaSliderThumbShape({required this.thumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // 1. Glow Central Intenso
    final Paint glowPaint = Paint()
      ..color = const Color(0xFFFF4D00).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, thumbRadius * 0.8, glowPaint);

    // 2. Cuerpo de la Esfera de Cristal
    final Rect sphereRect = Rect.fromCircle(center: center, radius: thumbRadius);
    final Paint spherePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.05),
          Colors.black.withOpacity(0.2),
        ],
        stops: const [0.0, 0.6, 1.0],
        center: const Alignment(-0.3, -0.3),
      ).createShader(sphereRect);
    canvas.drawCircle(center, thumbRadius, spherePaint);

    // 3. Núcleo Brillante (Hotspot)
    final Paint corePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFBD00), const Color(0xFFFF4D00)],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius * 0.4));
    canvas.drawCircle(center, thumbRadius * 0.4, corePaint);

    // 4. Reflejo Superior (Highlight)
    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center.translate(-thumbRadius * 0.3, -thumbRadius * 0.3), thumbRadius * 0.2, highlightPaint);

    // 5. Borde de Cristal
    final Paint borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
