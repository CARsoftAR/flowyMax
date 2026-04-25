import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/background_palette.dart';
import '../widgets/flowy_glass_card.dart';
import '../widgets/floating_player.dart';
import '../bloc/search_bloc.dart';
import '../bloc/player_bloc.dart';
import '../widgets/floating_navbar.dart';
import '../widgets/scale_on_press.dart';
import 'search_screen.dart';
import '../../injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final palette = di.sl<BackgroundPalette>();

    return BlocProvider(
      create: (context) => di.sl<SearchBloc>()..add(FetchTrending()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        body: Stack(
          children: [
            // ── CAPA 1: FONDO GLOBAL ─────────────────────────────────────────
            Container(
              width: double.infinity,
              height: double.infinity,
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
            
            _buildAtmosphere(palette),

            // ── CAPA 2: CONTENIDO DINÁMICO (Tabs) ────────────────────────────
            if (_selectedIndex == 0)
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFixedHeader(),
                    Expanded(
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state is SearchLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: Color(0xFFFF4D00)),
                            );
                          } else if (state is SearchLoaded) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                              itemCount: state.songs.length,
                              itemBuilder: (context, index) {
                                final song = state.songs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ScaleOnPress(
                                    onTap: () {
                                      context.read<PlayerBloc>().add(PlayTrack(song));
                                    },
                                    child: _buildTrackItem(song),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (_selectedIndex == 1)
              const SearchScreen()
            else
              const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white24))),

            // ── CAPA 3: UI FIJA (Null-Safe 3D Card & Navbar) ─────────────────
            BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, playerState) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (playerState.currentSong != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Dismissible(
                                key: ValueKey('player_${playerState.currentSong!.id}'),
                                direction: DismissDirection.horizontal,
                                onDismissed: (_) {
                                  context.read<PlayerBloc>().add(StopTrack());
                                },
                                child: const FloatingPlayer(),
                              ),
                            ),
                          FloatingNavbar(
                            selectedIndex: _selectedIndex,
                            onTap: (index) => setState(() => _selectedIndex = index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Buscador (Static)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: FlowyGlassCard(
            borderRadius: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.5), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search music...',
                      hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Moods (Static)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Text(
            'EXPLORA TU MOOD',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        _buildMoodsList(),

        // 3. Título Tendencias (Static)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Text(
            'Tendencias',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodsList() {
    final moods = [
      {'label': 'Día de lluvia', 'icon': Icons.umbrella_rounded, 'color': Colors.cyan},
      {'label': 'Modo bestia', 'icon': Icons.bolt_rounded, 'color': Colors.orange},
      {'label': 'Corazón roto', 'icon': Icons.heart_broken_rounded, 'color': Colors.deepPurpleAccent},
      {'label': 'Fiesta nocturna', 'icon': Icons.celebration_rounded, 'color': Colors.pinkAccent},
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: moods.length,
        itemBuilder: (context, i) {
          final mood = moods[i];
          final Color c = mood['color'] as Color;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: ScaleOnPress(
              onTap: () {},
              child: FlowyGlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mood['icon'] as IconData,
                        color: c.withOpacity(0.9),
                        size: 20,
                        shadows: [Shadow(color: c.withOpacity(0.5), blurRadius: 8)]),
                    const SizedBox(width: 10),
                    Text(
                      mood['label'] as String,
                      softWrap: false,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAtmosphere(BackgroundPalette palette) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -150,
          child: _GlowSphere(color: palette.primaryNeon.withOpacity(0.2), size: 700),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: _GlowSphere(color: palette.secondaryNeon.withOpacity(0.2), size: 700),
        ),
      ],
    );
  }

  Widget _buildTrackItem(dynamic song) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: song.coverUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.white10),
              errorWidget: (context, url, error) => const Icon(Icons.music_note, color: Colors.white24, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.artist,
                  style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowSphere extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowSphere({required this.color, required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _GlowPainter(color));
}

class _GlowPainter extends CustomPainter {
  final Color color;
  _GlowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
