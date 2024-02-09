import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/common/app_colors.dart';
import 'package:movie_app/feature/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:movie_app/feature/presentation/pages/movie_detail_screen.dart';
import 'feature/presentation/pages/movie_screen.dart';
import 'locator_service.dart';
import 'package:uni_links/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final ServiceLocator sl = ServiceLocator();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    getLinksStream().listen((String? link) {
      var uri = Uri.parse(link!);

      _handleDeepLink(uri);
    }, onError: (err) {});

    var initialLink = await getInitialLink();
    if (initialLink != null) {
      var uri = Uri.parse(initialLink);
      _handleDeepLink(uri);
    }
  }

  void _handleDeepLink(Uri uri) async {
    print("Received deeplink: $uri");
    if (uri.host == 'movie_info' && uri.pathSegments.length > 0) {
      final movieIdStr = uri.pathSegments.first;
      final movieId = int.tryParse(movieIdStr);
      if (movieId != null) {
        final movie = await ServiceLocator()
            .personLocalDataSource
            .getMovieFromCacheById(movieId);
        print(movieId);
        if (movie != null) {
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => MovieDetailPage(person: movie),
          ));
        } else {
          print("Movie with ID $movieId not found in cache.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final sl = ServiceLocator();

    return BlocProvider<MovieSearchBloc>(
      create: (context) => sl.movieSearchBloc,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          // backgroundColor: AppColors.mainBackground,
          scaffoldBackgroundColor: AppColors.mainBackground,
        ),
        home: const HomePage(),
        routes: {
          '/movie_info': (context) => MovieDetailPage(
                person:
                    ModalRoute.of(context)!.settings.arguments as MovieEntity,
              ),
        },
      ),
    );
  }
}
