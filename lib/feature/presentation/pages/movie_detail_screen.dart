import 'package:flutter/material.dart';
import 'package:movie_app/common/app_colors.dart';
import 'package:movie_app/feature/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/presentation/widgets/movie_cache_image_widget.dart';

class MovieDetailPage extends StatelessWidget {
  final MovieEntity person;

  const MovieDetailPage({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              person.title,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            MovieCacheImage(
              width: 260,
              height: 260,
              imageUrl: "https://image.tmdb.org/t/p/w500${person.posterPath}",
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              child: Text("Link - myapp://movie_info/${person.id.toString()}"),
              onTap: () async {
                print("Link - myapp://movie_info/${person.id.toString()}");
                // final movieId = person.id.toString();
                // final url = 'myapp://movie_info/$movieId';
                // print(' $url');
                // if (await canLaunch(url)) {
                //   await launch(url);
                // } else {
                //   print('Could not launch $url');
                // }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Raiting  ${person.voteAverage}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              person.overview,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
