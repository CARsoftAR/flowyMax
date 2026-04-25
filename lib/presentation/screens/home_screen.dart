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

            // ── CAPA 2: CONTENIDO SCROLLABLE ─────────────────────────────────
            SafeArea(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // 1. SliverAppBar (Search)
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        floating: true,
                        snap: true,
                        toolbarHeight: 64,
                        flexibleSpace: Padding(
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
                                Icon(Icons.mic_none_rounded, color: Colors.white.withOpacity(0.5), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2. Moods (Elastic Design)
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ),

                      // 3. Tendencias (22px, Poppins)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                        sliver: SliverToBoxAdapter(
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
                      ),

                      // 4. Song List
                      if (state is SearchLoading)
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(color: Color(0xFFFF4D00)),
                            ),
                          ),
                        )
                      else if (state is SearchLoaded)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
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
                              childCount: state.songs.length,
                            ),
                          ),
                        ),

                      const SliverPadding(padding: EdgeInsets.only(bottom: 180)),
                    ],
                  );
                },
              ),
            ),

            // ── CAPA 3: UI FIJA (Player & Navbar) ────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FloatingPlayer(),
                      const SizedBox(height: 2),
                      FloatingNavbar(
                        selectedIndex: _selectedIndex,
                        onTap: (index) => setState(() => _selectedIndex = index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodsList() {
    final moods = [
      {'label': 'Día de lluvia', 'icon': Icons.umbrella_rounded, 'color': Colors.cyan},
      {'label': 'Modo bestia', 'icon': Icons.bolt_rounded, 'color': Colors.orange},
      {'label': 'Corazón roto', 'icon': Icons.heart_broken_rounded, 'color': Colors.deepPurpleAccent},
      {'label': 'Fiesta nocturna', 'icon': Icons.celebration_rounded, 'color': Colors.pinkAccent},
      {'label': 'Momentos chill', 'icon': Icons.waves_rounded, 'color': Colors.blueAccent},
    ];

    return SizedBox(
      height: 64, // Sufficient height to prevent vertical cutting
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
                // NO fixed width: Elastic design based on padding
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row takes only needed width
                  children: [
                    Icon(mood['icon'] as IconData,
                        color: c.withOpacity(0.9),
                        size: 22,
                        shadows: [Shadow(color: c.withOpacity(0.5), blurRadius: 8)]),
                    const SizedBox(width: 12),
                    Text(
                      mood['label'] as String,
                      maxLines: 1,
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
          child: _GlowSphere(color: palette.primaryNeon.withOpacity(0.4), size: 700),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: _GlowSphere(color: palette.secondaryNeon.withOpacity(0.4), size: 700),
        ),
      ],
    );
  }

  Widget _buildTrackItem(dynamic song) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: song.coverUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.white10),
              errorWidget: (context, url, error) => const Icon(Icons.music_note, color: Colors.white24, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.artist,
                  style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_fill, color: const Color(0xFFFF4D00).withOpacity(0.8), size: 26),
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
