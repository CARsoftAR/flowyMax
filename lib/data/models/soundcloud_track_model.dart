import '../../domain/entities/song_entity.dart';

class SoundCloudTrackModel extends SongEntity {
  const SoundCloudTrackModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.streamUrl,
    required super.coverUrl,
    required super.duration,
  });

  factory SoundCloudTrackModel.fromJson(Map<String, dynamic> json) {
    return SoundCloudTrackModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Unknown Title',
      artist: json['user']?['username'] ?? 'Unknown Artist',
      streamUrl: json['stream_url'] ?? '',
      coverUrl: _parseCoverUrl(json['artwork_url'] ?? json['user']?['avatar_url']),
      duration: Duration(milliseconds: json['duration'] ?? 0),
    );
  }

  static String _parseCoverUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    // SoundCloud artwork URLs typically end in -large.jpg or similar.
    // We replace it with -t500x500 for better quality.
    if (url.contains('-large')) {
      return url.replaceAll('-large', '-t500x500');
    }
    return url;
  }

  SongEntity toEntity() {
    return SongEntity(
      id: id,
      title: title,
      artist: artist,
      streamUrl: streamUrl,
      coverUrl: coverUrl,
      duration: duration,
    );
  }
}
