// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/feature/domain/usecases/search_movie.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovie searchMovie;

  MovieSearchBloc({required this.searchMovie}) : super(MovieSearchEmpty()) {
    on<SearchMovies>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchMovies event, Emitter<MovieSearchState> emit) async {
    emit(MovieSearchLoading());
    final failureOrMovie =
        await searchMovie(SearchMovieParams(query: event.movieQuery));
    emit(failureOrMovie.fold(
        (failure) => MovieSearchError(message: _mapFailureToMessage(failure)),
        (person) => MovieSearchLoaded(movies: person)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
