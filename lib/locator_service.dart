import 'package:dio/dio.dart';

import 'package:movie_app/feature/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/feature/data/datasources/person_remote_data_source.dart';
import 'package:movie_app/feature/domain/repositories/movie_repository.dart';

import 'feature/data/repositories/movie_repository_impl.dart';

import 'feature/domain/usecases/search_movie.dart';

import 'feature/presentation/bloc/search_bloc/search_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  Dio? _dio;
  Dio get dio => _dio ??= Dio();

  MovieSearchBloc? _movieSearchBloc;
  MovieSearchBloc get movieSearchBloc =>
      _movieSearchBloc ??= MovieSearchBloc(searchMovie: searchPerson);

  SearchMovie? _searchPerson;
  SearchMovie get searchPerson =>
      _searchPerson ??= SearchMovie(personRepository);

  MovieRepository? _personRepository;
  MovieRepository get personRepository =>
      _personRepository ??= MovieRepositoryImpl(
        remoteDataSource: personRemoteDataSource,
        localDataSource: personLocalDataSource,
      );

  MovieRemoteDataSource? _personRemoteDataSource;
  MovieRemoteDataSource get personRemoteDataSource =>
      _personRemoteDataSource ??= MovieRemoteDataSourceImpl(dio: dio);

  MovieLocalDataSource? _personLocalDataSource;
  MovieLocalDataSource get personLocalDataSource => _personLocalDataSource ??=
      MovieLocalDataSourceImpl(databaseProvider: databaseProvider);

  DatabaseProvider? _databaseProvider;
  DatabaseProvider get databaseProvider =>
      _databaseProvider ??= DatabaseProvider.instance;
}
