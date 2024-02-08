class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String? posterPath;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    this.posterPath,
  });
}
