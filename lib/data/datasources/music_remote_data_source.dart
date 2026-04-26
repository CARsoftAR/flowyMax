import '../models/itunes_track_model.dart';
import '../../core/network/api_client.dart';

abstract class MusicRemoteDataSource {
  Future<List<ITunesTrackModel>> searchSongs(String query);
  Future<List<ITunesTrackModel>> getTrendingSongs();
  Future<List<ITunesTrackModel>> searchMood(String moodQuery);
  Future<String?> getITunesCover(String term);
  Future<String> getStreamUrl(String title, String artist);
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final ApiClient _apiClient;

  MusicRemoteDataSourceImpl(this._apiClient);

  static const String _iTunesBaseUrl = 'https://itunes.apple.com';

  @override
  Future<String?> getITunesCover(String term) async {
    try {
      final response = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': term,
          'entity': 'song',
          'limit': 1,
          'country': 'AR',
        },
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          final artworkUrl = results.first['artworkUrl100'] as String?;
          return artworkUrl?.replaceAll('100x100bb', '600x600bb');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ITunesTrackModel>> searchSongs(String query) async {
    try {
      final response = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': query,
          'entity': 'song',
          'limit': 50,
          'country': 'AR',
        },
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .where((json) => json['wrapperType'] == 'track' && json['kind'] == 'song')
            .map((json) => ITunesTrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ITunesTrackModel>> getTrendingSongs() async {
    try {
      final results = <ITunesTrackModel>[];
      
      // 1. Top Songs Argentina (Main feed)
      final arResponse = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': 'top songs',
          'entity': 'song',
          'limit': 30,
          'country': 'AR',
        },
      );
      
      if (arResponse.statusCode == 200) {
        final arResults = arResponse.data['results'] as List;
        results.addAll(arResults
            .where((json) => json['wrapperType'] == 'track' && json['kind'] == 'song')
            .map((json) => ITunesTrackModel.fromJson(json)));
      }

      // 2. Reggaeton & Trap Latino (Hits)
      final latinResponse = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': 'reggaeton 2024',
          'entity': 'song',
          'limit': 30,
          'country': 'MX',
        },
      );
      
      if (latinResponse.statusCode == 200) {
        final latinResults = latinResponse.data['results'] as List;
        results.addAll(latinResults
            .where((json) => json['wrapperType'] == 'track' && json['kind'] == 'song')
            .map((json) => ITunesTrackModel.fromJson(json)));
      }

      // 3. Trap Argentino (Specific request)
      final trapResponse = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': 'trap argentino',
          'entity': 'song',
          'limit': 20,
          'country': 'AR',
        },
      );
      
      if (trapResponse.statusCode == 200) {
        final trapResults = trapResponse.data['results'] as List;
        results.addAll(trapResults
            .where((json) => json['wrapperType'] == 'track' && json['kind'] == 'song')
            .map((json) => ITunesTrackModel.fromJson(json)));
      }

      // Mezclar resultados para mayor dinamismo
      results.shuffle();
      return results;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ITunesTrackModel>> searchMood(String moodQuery) async {
    try {
      final response = await _apiClient.get(
        '$_iTunesBaseUrl/search',
        queryParameters: {
          'term': moodQuery,
          'entity': 'song',
          'limit': 50,
          'country': 'AR',
        },
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .where((json) => json['wrapperType'] == 'track' && json['kind'] == 'song')
            .map((json) => ITunesTrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getStreamUrl(String title, String artist) async {
    try {
      final query = '$title $artist audio';
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
        
        final videoResponse = await _apiClient.get(
          'https://invidious.projectsegfau.lt/api/v1/videos/$videoId',
        );

        if (videoResponse.statusCode == 200) {
          final adaptiveFormats = videoResponse.data['adaptiveFormats'] as List;
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
}
