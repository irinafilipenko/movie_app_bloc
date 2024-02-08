// ignore_for_file: avoid_print

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:movie_app/feature/data/models/movie_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/error/exception.dart';

part 'movie_remote_data_source.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/search/movie")
  Future<HttpResponse> searchMovie(
      @Query("api_key") String apiKey, @Query("query") String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio _dio;
  late final ApiClient _apiClient;

  MovieRemoteDataSourceImpl({required Dio dio}) : _dio = dio {
    _apiClient = ApiClient(_dio);
  }

  @override
  Future<List<MovieModel>> searchMovie(String query) async {
    final apiKey = dotenv.env['API_KEY']!;
    final response = await _apiClient.searchMovie(apiKey, query);
    if (response.response.statusCode == 200) {
      final result = response.data;
      List<MovieModel> persons = (result['results'] as List)
          .map((person) => MovieModel.fromJson(person))
          .toList();
      return persons;
    } else {
      throw ServerException();
    }
  }
}

abstract class MovieRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<MovieModel>> searchMovie(String query);
}
