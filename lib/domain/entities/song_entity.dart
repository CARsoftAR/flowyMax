import 'package:equatable/equatable.dart';

class SongEntity extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String streamUrl;
  final String coverUrl;
  final Duration duration;

  const SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.streamUrl,
    required this.coverUrl,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, title, artist, streamUrl, coverUrl, duration];
}
