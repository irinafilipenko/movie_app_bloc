import 'package:movie_app/feature/domain/entities/movie_entity.dart';

abstract class MovieSearchState {
  const MovieSearchState();
}

class MovieSearchEmpty extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<MovieEntity> persons;

  const MovieSearchLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class MovieSearchError extends MovieSearchState {
  final String message;

  const MovieSearchError({required this.message});
}
