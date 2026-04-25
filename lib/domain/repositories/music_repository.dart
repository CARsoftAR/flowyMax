import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/song_entity.dart';

abstract class MusicRepository {
  Future<Either<Failure, List<SongEntity>>> searchSongs(String query);
  Future<Either<Failure, List<SongEntity>>> getTrendingSongs();
  Future<Either<Failure, String>> getStreamUrl(String title, String artist);
}
