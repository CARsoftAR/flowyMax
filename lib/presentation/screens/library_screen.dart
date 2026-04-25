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
          // ── CAPA 1: FONDO VAPOROSO DINÁMICO (Tonos Púrpuras y Azulados) ─────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0F1E),
                    Color(0xFF1A1A35), // Púrpura Profundo
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            top: -50,
            left: -100,
            child: _GlowAtmosphere(color: const Color(0xFF6B00FF).withOpacity(0.12), size: 600),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: _GlowAtmosphere(color: const Color(0xFF0055FF).withOpacity(0.1), size: 700),
          ),

          // ── CAPA 2: CONTENIDO ──────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // 1. HEADER PREMIUM
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

                // 2. SELECTORES DE CRISTAL (RESTAURACIÓN CRÍTICA DE TEXTOS)
                SizedBox(
                  height: 56,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildLibraryPill('Me gusta', Icons.favorite_rounded, const Color(0xFFFF2D55)),
                        const SizedBox(width: 12),
                        _buildLibraryPill('Recientes', Icons.access_time_filled_rounded, const Color(0xFF5856D6)),
                        const SizedBox(width: 12),
                        _buildLibraryPill('Descargas', Icons.download_rounded, const Color(0xFF34C759)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

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
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                            ),
                            child: const Icon(
                              Icons.library_music_outlined,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Tu biblioteca está vacía',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Comienza a explorar sonidos',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 100), // Aumentado para subir el botón

                        // 4. BOTÓN CREAR PLAYLIST (CRISTAL REAL + REPOSICIONADO)
                        ScaleOnPress(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 60), // Subido 40-60px respecto a antes
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF4D00).withOpacity(0.4),
                                  blurRadius: 15, // Resplandor de neón
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 19),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1), // Cristal real translúcido
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: const Color(0xFFFF4D00).withOpacity(0.9), // Hilo neón 1.2
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_rounded, color: Color(0xFFFF4D00), size: 24),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Crear playlist',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white, // Blanco nítido
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
              // TEXTO REFORZADO - USO DE TEXTO ESTÁNDAR PARA MÁXIMA COMPATIBILIDAD
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
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
