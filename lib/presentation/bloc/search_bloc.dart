import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/usecases/search_songs.dart';
import '../../domain/usecases/get_trending_songs.dart';

// Events
abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrending extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

// States
abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<SongEntity> songs;
  SearchLoaded(this.songs);
  @override
  List<Object?> get props => [songs];
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchSongs searchSongs;
  final GetTrendingSongs getTrendingSongs;

  SearchBloc({
    required this.searchSongs,
    required this.getTrendingSongs,
  }) : super(SearchInitial()) {
    on<FetchTrending>((event, emit) async {
      emit(SearchLoading());
      final failureOrSongs = await getTrendingSongs();
      failureOrSongs.fold(
        (failure) => emit(SearchError('Error loading trending')),
        (songs) => emit(SearchLoaded(songs)),
      );
    });

    on<SearchQueryChanged>((event, emit) async {
      if (event.query.isEmpty) {
        add(FetchTrending());
        return;
      }
      emit(SearchLoading());
      final failureOrSongs = await searchSongs(event.query);
      failureOrSongs.fold(
        (failure) => emit(SearchError('Error searching songs')),
        (songs) => emit(SearchLoaded(songs)),
      );
    });
  }
}
