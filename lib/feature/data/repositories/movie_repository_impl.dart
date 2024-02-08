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
  // final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    //   required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovie(String query) async {
    return await _getPersons(() {
      return remoteDataSource.searchMovie(query);
    });
  }

  Future<Either<Failure, List<MovieModel>>> _getPersons(
      Future<List<MovieModel>> Function() getPersons) async {
    try {
      // Пытаемся получить данные из удалённого источника
      final remotePerson = await getPersons();
      // Кешируем полученные данные
      await localDataSource.moviesToCache(remotePerson);
      // Возвращаем успешный результат с данными из удалённого источника
      return Right(remotePerson);
    } on ServerException {
      // В случае ошибки при получении данных из удалённого источника
      // пытаемся получить данные из локального кеша
      try {
        final localPerson = await localDataSource.getLastMoviesFromCache();
        // Возвращаем успешный результат с данными из локального кеша
        return Right(localPerson);
      } on CacheException {
        // В случае ошибки при получении данных из локального кеша
        // возвращаем ошибку кеша
        return Left(CacheFailure());
      }
    }
  }
}
