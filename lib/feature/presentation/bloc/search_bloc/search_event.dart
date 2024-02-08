abstract class MovieSearchEvent {
  const MovieSearchEvent();
}

class SearchMovies extends MovieSearchEvent {
  final String personQuery;

  const SearchMovies(this.personQuery);
}
