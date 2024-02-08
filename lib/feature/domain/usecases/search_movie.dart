import 'package:dartz/dartz.dart';

import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/feature/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/domain/repositories/movie_repository.dart';

class SearchMovie extends UseCase<List<MovieEntity>, SearchMovieParams> {
  final MovieRepository movieRepository;

  SearchMovie(this.movieRepository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(
      SearchMovieParams params) async {
    return await movieRepository.searchMovie(params.query);
  }
}

class SearchMovieParams {
  final String query;

  const SearchMovieParams({required this.query});
}
