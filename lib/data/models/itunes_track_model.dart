import '../../domain/entities/song_entity.dart';

class ITunesTrackModel extends SongEntity {
  const ITunesTrackModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.streamUrl,
    required super.coverUrl,
    required super.duration,
  });

  factory ITunesTrackModel.fromJson(Map<String, dynamic> json) {
    return ITunesTrackModel(
      id: json['trackId']?.toString() ?? '',
      title: json['trackName'] ?? 'Unknown Title',
      artist: json['artistName'] ?? 'Unknown Artist',
      streamUrl: json['previewUrl'] ?? '',
      coverUrl: _parseCoverUrl(json['artworkUrl100'] as String?),
      duration: Duration(milliseconds: json['trackTimeMillis'] ?? 0),
    );
  }

  static String _parseCoverUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url.replaceAll('100x100bb', '600x600bb');
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