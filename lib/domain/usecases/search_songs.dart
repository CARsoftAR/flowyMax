import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class SearchSongs {
  final MusicRepository repository;

  SearchSongs(this.repository);

  Future<Either<Failure, List<SongEntity>>> call(String query) async {
    return await repository.searchSongs(query);
  }
}
