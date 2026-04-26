import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/flowy_glass_card.dart';
import '../widgets/floating_player.dart';
import '../bloc/search_bloc.dart';
import '../bloc/player_bloc.dart';
import '../widgets/floating_navbar.dart';
import '../widgets/scale_on_press.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'stats_screen.dart';

// ─── Modelo liviano para el fallback hardcoded ───────────────────────────────
class _FallbackSong {
  final String id, title, artist, coverUrl;
  const _FallbackSong({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
  });
}

const _kFallback = [
  _FallbackSong(
    id: 'f1',
    title: 'Monaco',
    artist: 'Bad Bunny',
    coverUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/9e/7c/54/9e7c541d-6df6-18b2-91ad-aac3a35c41b0/196626918610.jpg/600x600bb.jpg',
  ),
  _FallbackSong(
    id: 'f2',
    title: 'TQG',
    artist: 'Karol G & Shakira',
    coverUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/8e/5f/97/8e5f97b0-4dd5-87a5-f025-f5e9ffbbc3d3/196626918627.jpg/600x600bb.jpg',
  ),
  _FallbackSong(
    id: 'f3',
    title: 'Cruel Summer',
    artist: 'Taylor Swift',
    coverUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/90/87/33/90873327-a38b-4a7e-b3fd-b74ea2c2fcdc/22UMGIM85845.rgb.jpg/600x600bb.jpg',
  ),
  _FallbackSong(
    id: 'f4',
    title: 'Provenza',
    artist: 'Karol G',
    coverUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/11/36/65/113665bc-2e18-1abd-e4e0-0dc9b2efb5e0/22UMGIM35726.rgb.jpg/600x600bb.jpg',
  ),
  _FallbackSong(
    id: 'f5',
    title: 'Shakira: Bzrp Music Sessions Vol. 53',
    artist: 'Bizarrap & Shakira',
    coverUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/b4/2b/91/b42b91c6-59e7-e71c-e35d-8ee3a4d6e82c/23UMGIM00539.rgb.jpg/600x600bb.jpg',
  ),
];

// ─── HomeScreen ───────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedMoodIndex = -1;

  // Lista visible inicial = fallback hardcoded; se reemplaza cuando llega la API
  List<dynamic> _displaySongs = List.unmodifiable(_kFallback);

  @override
  void initState() {
    super.initState();
    // Dispara la búsqueda real inmediatamente sin bloquear la UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SearchBloc>().add(FetchTrending());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escucha cambios del Bloc para actualizar la lista cuando la API responde
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchLoaded && state.songs.isNotEmpty) {
          setState(() => _displaySongs = state.songs);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparente — el gradiente vive en el Stack
        body: Stack(
          children: [

            // ═══════════════════════════════════════════════════════════════
            // CAPA 0 — GRADIENTE DE FONDO (Púrpura → Verde Petróleo)
            // Siempre el primer hijo del Stack; nunca gris.
            // ═══════════════════════════════════════════════════════════════
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2A1245), // Púrpura oscuro
                    Color(0xFF0F0F20), // Centro casi negro
                    Color(0xFF0D2820), // Verde petróleo
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Orbes atmosféricos — nunca bloques sólidos
            Positioned(
              top: -120,
              left: -80,
              child: _Glow(color: const Color(0xFF8B2BE2).withOpacity(0.18), size: 500),
            ),
            Positioned(
              bottom: -180,
              right: -80,
              child: _Glow(color: const Color(0xFF00C896).withOpacity(0.14), size: 600),
            ),

            // ═══════════════════════════════════════════════════════════════
            // CAPA 1 — CONTENIDO POR PESTAÑA
            // ═══════════════════════════════════════════════════════════════
            if (_selectedIndex == 0) _buildTendenciasTab(),
            if (_selectedIndex == 1) const SearchScreen(),
            if (_selectedIndex == 2) const LibraryScreen(),
            if (_selectedIndex == 3) const StatsScreen(),

            // ═══════════════════════════════════════════════════════════════
            // CAPA 2 — MINI-PLAYER (deslizable) + NAVBAR — Siempre arriba
            // ═══════════════════════════════════════════════════════════════
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
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Dismissible(
                                key: ValueKey('mp_${playerState.currentSong!.id}'),
                                direction: DismissDirection.horizontal,
                                onDismissed: (_) =>
                                    context.read<PlayerBloc>().add(StopTrack()),
                                child: const FloatingPlayer(),
                              ),
                            ),
                          FloatingNavbar(
                            selectedIndex: _selectedIndex,
                            onTap: (i) => setState(() => _selectedIndex = i),
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

  // ── Tab Tendencias ──────────────────────────────────────────────────────────
  Widget _buildTendenciasTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Encabezado fijo con Glassmorphism
        SliverPersistentHeader(
          pinned: true,
          delegate: _GlassHeaderDelegate(
            selectedMoodIndex: _selectedMoodIndex,
            onMoodSelected: (i) => setState(() => _selectedMoodIndex = i),
          ),
        ),
        // Lista de canciones
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 160),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = _displaySongs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ScaleOnPress(
                    onTap: () => context.read<PlayerBloc>().add(PlayTrack(song)),
                    child: _TrackCard(song: song),
                  ),
                );
              },
              childCount: _displaySongs.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Encabezado Fijo con Glassmorphism ───────────────────────────────────────
class _GlassHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int selectedMoodIndex;
  final ValueChanged<int> onMoodSelected;

  const _GlassHeaderDelegate({
    required this.selectedMoodIndex,
    required this.onMoodSelected,
  });

  static const _moods = [
    {'label': 'Relajación', 'icon': Icons.spa_rounded, 'color': Color(0xFF00BCD4)},
    {'label': 'Energía',    'icon': Icons.bolt_rounded, 'color': Color(0xFFFF9800)},
    {'label': 'Enfoque',    'icon': Icons.psychology_rounded, 'color': Color(0xFF9C27B0)},
    {'label': 'Romance',    'icon': Icons.favorite_rounded, 'color': Color(0xFFE91E63)},
  ];

  @override
  double get minExtent => 215;
  @override
  double get maxExtent => 215;

  @override
  bool shouldRebuild(covariant _GlassHeaderDelegate old) =>
      old.selectedMoodIndex != selectedMoodIndex;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: Colors.black.withOpacity(0.08), // Casi transparente — no gris
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Título FLOWY
                  Text(
                    'FLOWY',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Buscador Glass
                  FlowyGlassCard(
                    borderRadius: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.white.withOpacity(0.4), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Buscar artistas...',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.white30, fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Moods "Jewelry Style"
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _moods.length,
                      itemBuilder: (context, i) {
                        final m = _moods[i];
                        final selected = selectedMoodIndex == i;
                        final c = m['color'] as Color;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ScaleOnPress(
                            onTap: () => onMoodSelected(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? Colors.white.withOpacity(0.35)
                                      : Colors.white.withOpacity(0.08),
                                  width: 0.5,
                                ),
                                boxShadow: selected
                                    ? [BoxShadow(color: c.withOpacity(0.25), blurRadius: 12)]
                                    : [],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: selected ? 28 : 10,
                                    sigmaY: selected ? 28 : 10,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    color: selected
                                        ? Colors.white.withOpacity(0.14)
                                        : Colors.white.withOpacity(0.04),
                                    child: Row(
                                      children: [
                                        Icon(m['icon'] as IconData,
                                            color: selected ? Colors.white : c.withOpacity(0.5),
                                            size: 15),
                                        const SizedBox(width: 6),
                                        Text(
                                          m['label'] as String,
                                          style: GoogleFonts.poppins(
                                            color: selected
                                                ? Colors.white
                                                : Colors.white38,
                                            fontSize: 11,
                                            fontWeight: selected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Título Tendencias — Poppins Medium 24
                  Text(
                    'Tendencias',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.4,
                    ),
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

// ─── Tarjeta de Pista ─────────────────────────────────────────────────────────
class _TrackCard extends StatelessWidget {
  final dynamic song;
  const _TrackCard({required this.song});

  String get _coverUrl {
    if (song is _FallbackSong) return (song as _FallbackSong).coverUrl;
    return song.coverUrl as String;
  }

  String get _title {
    if (song is _FallbackSong) return (song as _FallbackSong).title;
    return song.title as String;
  }

  String get _artist {
    if (song is _FallbackSong) return (song as _FallbackSong).artist;
    return song.artist as String;
  }

  @override
  Widget build(BuildContext context) {
    return FlowyGlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: CachedNetworkImage(
              imageUrl: _coverUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.white10),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.music_note_rounded, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _artist,
                  style: GoogleFonts.poppins(
                      color: Colors.white54, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_outline_rounded,
              color: Colors.white.withOpacity(0.08), size: 24),
        ],
      ),
    );
  }
}

// ─── Orbe de brillo atmosférico ──────────────────────────────────────────────
class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _GlowPainter(color));
}

class _GlowPainter extends CustomPainter {
  final Color color;
  const _GlowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
