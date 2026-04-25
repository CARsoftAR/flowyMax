import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import '../models/soundcloud_track_model.dart';
import '../../core/network/api_client.dart';

abstract class MusicRemoteDataSource {
  Future<List<SoundCloudTrackModel>> searchSongs(String query);
  Future<List<SoundCloudTrackModel>> getTrendingSongs();
  Future<String?> getITunesCover(String term);
  Future<String> getStreamUrl(String title, String artist);
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final SoundcloudClient _sc;
  final ApiClient _apiClient;

  MusicRemoteDataSourceImpl(this._sc, this._apiClient);

  @override
  Future<String?> getITunesCover(String term) async {
    try {
      final response = await _apiClient.get(
        'https://itunes.apple.com/search',
        queryParameters: {'term': term, 'entity': 'song', 'limit': 1},
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          final artworkUrl = results.first['artworkUrl100'] as String?;
          // Forzar alta resolución
          return artworkUrl?.replaceAll('100x100bb', '600x600bb');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<SoundCloudTrackModel>> searchSongs(String query) async {
    try {
      final stream = _sc.search(query, searchFilter: SearchFilter.tracks);
      final searchResultPage = await stream.first;
      final tracks = searchResultPage.whereType<TrackSearchResult>().toList();
      return Future.wait(tracks.map((track) => _buildModel(track)));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SoundCloudTrackModel>> getTrendingSongs() async {
    try {
      final stream = _sc.search('Trending Music', searchFilter: SearchFilter.tracks);
      final searchResultPage = await stream.first;
      final tracks = searchResultPage.whereType<TrackSearchResult>().toList();
      return Future.wait(tracks.map((track) => _buildModel(track)));
    } catch (e) {
      rethrow;
    }
  }

  /// Builds a SoundCloudTrackModel with an iTunes cover fallback.
  Future<SoundCloudTrackModel> _buildModel(TrackSearchResult track) async {
    String coverUrl = _parseCoverUrl(track.artworkUrl?.toString());

    // If SoundCloud gave us no artwork, fall back to iTunes high-res cover
    if (coverUrl.isEmpty) {
      final searchTerm = '${track.title} ${track.user?.username ?? ''}';
      coverUrl = await getITunesCover(searchTerm) ?? '';
    }

    return SoundCloudTrackModel(
      id: track.id.toString(),
      title: track.title,
      artist: track.user?.username ?? 'Unknown Artist',
      streamUrl: '',
      coverUrl: coverUrl,
      duration: Duration(milliseconds: (track.duration * 1000).toInt()),
    );
  }

  @override
  Future<String> getStreamUrl(String title, String artist) async {
    try {
      final query = '$title $artist audio';
      // Use a reliable Invidious instance
      final searchResponse = await _apiClient.get(
        'https://invidious.projectsegfau.lt/api/v1/search',
        queryParameters: {
          'q': query,
          'type': 'video',
          'sort_by': 'relevance',
        },
      );

      if (searchResponse.statusCode == 200 && (searchResponse.data as List).isNotEmpty) {
        final videoId = searchResponse.data[0]['videoId'];
        
        // Get the actual stream URL
        final videoResponse = await _apiClient.get(
          'https://invidious.projectsegfau.lt/api/v1/videos/$videoId',
        );

        if (videoResponse.statusCode == 200) {
          final adaptiveFormats = videoResponse.data['adaptiveFormats'] as List;
          // Look for audio only streams with the best bitrate
          final audioStream = adaptiveFormats.firstWhere(
            (format) => format['type'].toString().contains('audio'),
            orElse: () => adaptiveFormats.first,
          );
          return audioStream['url'] as String;
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  String _parseCoverUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    // SoundCloud artwork URLs typically end in -large.jpg. 
    // We force -t500x500 for maximum quality as requested.
    if (url.contains('-large')) {
      return url.replaceAll('-large', '-t500x500');
    }
    return url;
  }
}
