import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/exception.dart';
import 'package:movie_app/core/error/failure.dart';

import 'package:movie_app/feature/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/feature/data/datasources/person_remote_data_source.dart';
import 'package:movie_app/feature/data/models/movie_model.dart';
import 'package:movie_app/feature/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovie(String query) async {
    return await _getMovie(() {
      return remoteDataSource.searchMovie(query);
    });
  }

  Future<Either<Failure, List<MovieModel>>> _getMovie(
      Future<List<MovieModel>> Function() getMovies) async {
    try {
      // Пытаемся получить данные из удалённого источника
      final remoteMovie = await getMovies();
      // Кешируем полученные данные
      await localDataSource.moviesToCache(remoteMovie);
      // Возвращаем успешный результат с данными из удалённого источника
      return Right(remoteMovie);
    } on ServerException {
      // В случае ошибки при получении данных из удалённого источника
      // пытаемся получить данные из локального кеша
      try {
        final localMovie = await localDataSource.getLastMoviesFromCache();
        // Возвращаем успешный результат с данными из локального кеша
        return Right(localMovie);
      } on CacheException {
        // В случае ошибки при получении данных из локального кеша
        // возвращаем ошибку кеша
        return Left(CacheFailure());
      }
    }
  }
}
