import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class SearchMood {
  final MusicRepository repository;

  SearchMood(this.repository);

  Future<Either<Failure, List<SongEntity>>> call(String moodQuery) async {
    return await repository.searchMood(moodQuery);
  }
}