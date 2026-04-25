import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/scale_on_press.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparente para ver el fondo global
      body: Stack(
        children: [
          // ── CAPA 1: INMERSIÓN TOTAL (Fondo Vaporoso) ───────────────────────
          // Nota: El fondo ya está en el Stack de HomeScreen, pero aseguramos la inmersión
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
          
          // Esferas de luz vaporosas (ADN Flowy)
          Positioned(
            top: -150,
            left: -100,
            child: _GlowSphere(color: const Color(0xFF4A00E0).withOpacity(0.15), size: 600),
          ),
          Positioned(
            bottom: 50,
            right: -150,
            child: _GlowSphere(color: const Color(0xFFFF4D00).withOpacity(0.12), size: 700),
          ),

          // ── CAPA 2: CONTENIDO ──────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                
                // 1. BARRA DE BÚSQUEDA DE CRISTAL (Glassmorphism)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08), // Opacidad mínima
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: Colors.white38, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'Buscar música, artistas...',
                                  hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. SELECTORES TRANSLÚCIDOS
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildFrostedPill('Música', isActive: true),
                      const SizedBox(width: 12),
                      _buildFrostedPill('Audiolibros', isActive: false),
                      const SizedBox(width: 12),
                      _buildFrostedPill('Podcasts', isActive: false),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    'Explorar por Interés',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. CUADRÍCULA DE JOYERÍA DIGITAL (Tarjetas de Cristal)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1.05,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildJewelCard('Rock', const Color(0xFFFF4B2B), Icons.electric_bolt_outlined),
                      _buildJewelCard('Heavy Metal', const Color(0xFF434343), Icons.settings_input_component_outlined),
                      _buildJewelCard('Pop', const Color(0xFF8E2DE2), Icons.auto_awesome_outlined),
                      _buildJewelCard('Reggaeton', const Color(0xFFFFB75E), Icons.whatshot_outlined), // Icono conceptual
                      _buildJewelCard('Lo-Fi', const Color(0xFF00B4DB), Icons.filter_drama_outlined),
                      _buildJewelCard('Jazz', const Color(0xFF000000), Icons.nightlight_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrostedPill(String label, {bool isActive = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF4D00).withOpacity(0.15) : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isActive ? const Color(0xFFFF4D00) : Colors.white.withOpacity(0.1),
              width: isActive ? 1.2 : 0.6,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isActive ? Colors.white : Colors.white38,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJewelCard(String title, Color color, IconData icon) {
    return ScaleOnPress(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                // 50% opacity colored crystal
                color: color.withOpacity(0.45),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.6),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Icono de fondo (Efecto profundidad)
                  Positioned(
                    bottom: -15,
                    right: -15,
                    child: Icon(icon, color: Colors.white.withOpacity(0.08), size: 90),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icono Premium Flotante
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowSphere extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowSphere({required this.color, required this.size});

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
