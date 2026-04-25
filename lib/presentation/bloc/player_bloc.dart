import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/usecases/get_stream_url.dart';

// Events
abstract class PlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayTrack extends PlayerEvent {
  final SongEntity song;
  PlayTrack(this.song);
  @override
  List<Object?> get props => [song];
}

class TogglePause extends PlayerEvent {}

class UpdatePosition extends PlayerEvent {
  final Duration position;
  UpdatePosition(this.position);
}

// States
class PlayerState extends Equatable {
  final SongEntity? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;

  const PlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  PlayerState copyWith({
    SongEntity? currentSong,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [currentSong, isPlaying, isLoading, position, duration];
}

// Bloc
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer _player;
  final GetStreamUrl _getStreamUrl;

  PlayerBloc({
    required AudioPlayer player,
    required GetStreamUrl getStreamUrl,
  }) : _player = player,
       _getStreamUrl = getStreamUrl,
       super(const PlayerState()) {
    
    on<PlayTrack>(_onPlayTrack);
    on<TogglePause>(_onTogglePause);
    on<UpdatePosition>((event, emit) => emit(state.copyWith(position: event.position)));

    // Listen to player streams
    _player.positionStream.listen((pos) => add(UpdatePosition(pos)));
    _player.durationStream.listen((dur) => emit(state.copyWith(duration: dur ?? Duration.zero)));
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        // Handle auto-next here if needed
      }
    });
  }

  Future<void> _onPlayTrack(PlayTrack event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(currentSong: event.song, isLoading: true, isPlaying: false));
    
    final result = await _getStreamUrl(event.song.title, event.song.artist);
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (streamUrl) async {
        try {
          await _player.setUrl(streamUrl);
          _player.play();
          emit(state.copyWith(isLoading: false, isPlaying: true));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      },
    );
  }

  void _onTogglePause(TogglePause event, Emitter<PlayerState> emit) {
    if (_player.playing) {
      _player.pause();
      emit(state.copyWith(isPlaying: false));
    } else {
      _player.play();
      emit(state.copyWith(isPlaying: true));
    }
  }
}
