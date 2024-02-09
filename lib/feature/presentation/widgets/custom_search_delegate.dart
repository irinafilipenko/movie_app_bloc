// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/feature/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:movie_app/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for cinema...');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        tooltip: 'Back',
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter at least 2 characters to search'),
            duration: Duration(seconds: 2),
          ),
        );
      });

      return Container();
    }
    print('Inside custom search delegate and search query is $query');

    BlocProvider.of<MovieSearchBloc>(context, listen: false)
        .add(SearchMovies(query));

    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieSearchLoaded) {
          final movieList = state.movies;
          if (movieList.isEmpty) {
            return _showErrorText('No Cinema with that name found');
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: movieList.isNotEmpty ? movieList.length : 0,
            itemBuilder: (context, index) {
              MovieEntity result = movieList[index];
              return SearchResult(personResult: result);
            },
          );
        } else if (state is MovieSearchError) {
          return _showErrorText(state.message);
        } else {
          return const Center(
            child: Icon(Icons.now_wallpaper),
          );
        }
      },
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // if (query.isNotEmpty) {
    return Container();
  }
}
