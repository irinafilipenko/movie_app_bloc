abstract class MovieSearchEvent {
  const MovieSearchEvent();
}

class SearchMovies extends MovieSearchEvent {
  final String movieQuery;

  const SearchMovies(this.movieQuery);
}
