import 'package:flutter/material.dart';

import 'package:movie_app/feature/presentation/widgets/movies_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: MoviesList(),
    );
  }
}
