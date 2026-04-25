import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class GetTrendingSongs {
  final MusicRepository repository;

  GetTrendingSongs(this.repository);

  Future<Either<Failure, List<SongEntity>>> call() async {
    return await repository.getTrendingSongs();
  }
}
