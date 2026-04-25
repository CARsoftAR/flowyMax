import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/player_bloc.dart';

class FloatingPlayer extends StatelessWidget {
  const FloatingPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          final hasSong = state.currentSong != null;

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // PREMIUM GLASS: white with 0.05 opacity + BackdropFilter
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // Album Art
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: hasSong ? [
                                  BoxShadow(
                                    color: const Color(0xFFFF4D00).withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  )
                                ] : [],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: hasSong
                                    ? CachedNetworkImage(
                                        imageUrl: state.currentSong!.coverUrl,
                                        width: 52,
                                        height: 52,
                                        fit: BoxFit.cover,
                                        fadeInDuration: const Duration(milliseconds: 300),
                                        placeholder: (context, url) =>
                                            Container(color: Colors.white10),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.music_note,
                                                color: Colors.white24),
                                      )
                                    : Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.1),
                                              Colors.white.withOpacity(0.05),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: const Icon(
                                            Icons.music_note_rounded,
                                            color: Colors.white24,
                                            size: 28),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Track Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hasSong
                                        ? state.currentSong!.title
                                        : 'Selecciona una canción',
                                    style: TextStyle(
                                      color: hasSong ? Colors.white : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w600, // Semi Bold
                                      fontSize: 16,
                                      letterSpacing: -0.2, // Tighter premium feel
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hasSong
                                        ? state.currentSong!.artist
                                        : 'Flowy Premium Experience',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Controls with GLOW
                            Row(
                              children: [
                                if (state.isLoading)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFFFF4D00)),
                                    ),
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: hasSong ? [
                                        BoxShadow(
                                          color: const Color(0xFFFF4D00).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        )
                                      ] : [],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        state.isPlaying
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_filled_rounded,
                                        color: hasSong ? const Color(0xFFFF4D00) : Colors.white24,
                                        size: 44,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: hasSong
                                          ? () {
                                              context
                                                  .read<PlayerBloc>()
                                                  .add(TogglePause());
                                            }
                                          : null,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Progress Bar with GLOW
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Stack(
                            children: [
                              Container(
                                height: 3,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final progress = state.duration.inMilliseconds > 0
                                      ? state.position.inMilliseconds /
                                          state.duration.inMilliseconds
                                      : 0.0;
                                  return Container(
                                    height: 3,
                                    width: constraints.maxWidth * progress,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF4D00),
                                          Color(0xFFFF8C00)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF4D00)
                                              .withOpacity(0.6),
                                          blurRadius: 12, // Enhanced neon glow
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
