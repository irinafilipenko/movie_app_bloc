import 'package:flutter/material.dart';

import 'package:movie_app/feature/presentation/widgets/custom_search_delegate.dart';

class MoviesList extends StatelessWidget {
  MoviesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 50,
            ),
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
          const Text('Press to begin search')
        ],
      ),
    );
  }
}
