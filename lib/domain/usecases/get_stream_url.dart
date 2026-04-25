import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/music_repository.dart';

class GetStreamUrl {
  final MusicRepository repository;

  GetStreamUrl(this.repository);

  Future<Either<Failure, String>> call(String title, String artist) async {
    return await repository.getStreamUrl(title, artist);
  }
}
