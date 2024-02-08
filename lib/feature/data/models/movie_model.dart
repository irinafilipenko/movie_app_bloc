import 'package:movie_app/feature/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    required id,
    required title,
    required overview,
    required voteAverage,
    required posterPath,
  }) : super(
            id: id,
            title: title,
            overview: overview,
            voteAverage: voteAverage,
            posterPath: posterPath);

  factory MovieModel.fromJson(Map<dynamic, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      voteAverage: json['vote_average'] as double,
      posterPath: json['poster_path'] == null
          ? "/sTuXDWacwdcMS7NNLaynkfVBZkr.jpg"
          : json['poster_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      "vote_average": voteAverage,
      'poster_path': posterPath,
    };
  }
}
