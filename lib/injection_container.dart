import 'dart:math';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import 'core/theme/background_palette.dart';
import 'core/network/api_client.dart';
import 'data/datasources/music_remote_data_source.dart';
import 'data/repositories/music_repository_impl.dart';
import 'domain/repositories/music_repository.dart';
import 'domain/usecases/search_songs.dart';
import 'domain/usecases/get_trending_songs.dart';
import 'domain/usecases/get_stream_url.dart';
import 'presentation/bloc/search_bloc.dart';
import 'presentation/bloc/player_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Explicit Random Palette Selection on Initialization
  final random = Random();
  final palettes = BackgroundPalette.presets;
  final selectedIndex = random.nextInt(palettes.length);
  final randomPalette = palettes[selectedIndex];
  
  // Clean registration to ensure fresh palette per app start
  if (sl.isRegistered<BackgroundPalette>()) {
    sl.unregister<BackgroundPalette>();
  }
  sl.registerSingleton<BackgroundPalette>(randomPalette);

  // External (Registered as Lazy but will be instantiated when needed)
  if (!sl.isRegistered<Dio>()) sl.registerLazySingleton(() => Dio());
  if (!sl.isRegistered<SoundcloudClient>()) sl.registerLazySingleton(() => SoundcloudClient());
  if (!sl.isRegistered<AudioPlayer>()) sl.registerLazySingleton(() => AudioPlayer());

  // Use cases
  sl.registerLazySingleton(() => SearchSongs(sl()));
  sl.registerLazySingleton(() => GetTrendingSongs(sl()));
  sl.registerLazySingleton(() => GetStreamUrl(sl()));

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Data sources
  sl.registerLazySingleton<MusicRemoteDataSource>(
    () => MusicRemoteDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(remoteDataSource: sl()),
  );

  // Blocs
  sl.registerFactory(
    () => SearchBloc(
      searchSongs: sl(),
      getTrendingSongs: sl(),
    ),
  );
  sl.registerFactory(
    () => PlayerBloc(
      player: sl(),
      getStreamUrl: sl(),
    ),
  );
}
