import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/scale_on_press.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── CAPA 1: FONDO VAPOROSO DINÁMICO (Atmosphere ADN) ────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0F1E),
                    Color(0xFF0B0E14),
                  ],
                ),
              ),
            ),
          ),
          
          // Luces vaporosas (Tonos púrpuras y azulados profundos solicitados)
          Positioned(
            top: -100,
            left: -150,
            child: _GlowAtmosphere(color: const Color(0xFF6B00FF).withOpacity(0.15), size: 700), // Púrpura Profundo
          ),
          Positioned(
            bottom: 100,
            right: -200,
            child: _GlowAtmosphere(color: const Color(0xFF0055FF).withOpacity(0.12), size: 800), // Azulado
          ),
          Positioned(
            top: 200,
            right: 0,
            child: _GlowAtmosphere(color: const Color(0xFFFF4D00).withOpacity(0.08), size: 500), // Toque naranja
          ),

          // ── CAPA 2: CONTENIDO ──────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // 1. TÍTULO CON SHADERMASK (Metálico)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFB0B0C0)],
                    ).createShader(bounds),
                    child: Text(
                      'Tu Biblioteca',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 2. SELECTORES DE CRISTAL (RESTAURACIÓN DE TEXTOS)
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildLibraryPill('Me gusta', Icons.favorite_rounded, const Color(0xFFFF2D55)),
                      const SizedBox(width: 14),
                      _buildLibraryPill('Recientes', Icons.access_time_filled_rounded, const Color(0xFF5856D6)),
                      const SizedBox(width: 14),
                      _buildLibraryPill('Descargas', Icons.download_rounded, const Color(0xFF34C759)),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 3. CUERPO (Grabado Láser)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono grabado (Opacity 40%)
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_motion_outlined,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          'Tu biblioteca está vacía',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Comienza a explorar sonidos',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // 4. BOTÓN CREAR PLAYLIST (VIDRIO ESMERILADO + GLOW NARANJA)
                        ScaleOnPress(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF4D00).withOpacity(0.4),
                                  blurRadius: 15, // Glow dinámico solicitado
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1), // Cristal translúcido
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: const Color(0xFFFF4D00).withOpacity(0.9), // Hilo de luz 1.2
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_rounded, color: Color(0xFFFF4D00), size: 26),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Crear playlist',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryPill(String label, IconData icon, Color accentColor) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accentColor.withOpacity(0.9), size: 18),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white, // Blanco nítido
                    fontWeight: FontWeight.w500, // Medium 14px
                    fontSize: 14,
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

class _GlowAtmosphere extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowAtmosphere({required this.color, required this.size});

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
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
