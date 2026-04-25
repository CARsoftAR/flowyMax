import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasources/music_remote_data_source.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource remoteDataSource;

  MusicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SongEntity>>> searchSongs(String query) async {
    try {
      final models = await remoteDataSource.searchSongs(query);
      
      final entities = await Future.wait(models.map((model) async {
        final iTunesCover = await remoteDataSource.getITunesCover('${model.title} ${model.artist}');
        return SongEntity(
          id: model.id,
          title: model.title,
          artist: model.artist,
          streamUrl: model.streamUrl,
          coverUrl: iTunesCover ?? model.coverUrl,
          duration: model.duration,
        );
      }));

      return Right(entities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getTrendingSongs() async {
    try {
      final models = await remoteDataSource.getTrendingSongs();
      
      final entities = await Future.wait(models.map((model) async {
        final iTunesCover = await remoteDataSource.getITunesCover('${model.title} ${model.artist}');
        return SongEntity(
          id: model.id,
          title: model.title,
          artist: model.artist,
          streamUrl: model.streamUrl,
          coverUrl: iTunesCover ?? model.coverUrl,
          duration: model.duration,
        );
      }));

      return Right(entities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getStreamUrl(String title, String artist) async {
    try {
      final url = await remoteDataSource.getStreamUrl(title, artist);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
