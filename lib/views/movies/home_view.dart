import 'package:flutter/material.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/widgets/movies_slider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 22, 22),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MoviesSlider(
              movies: moviesProvider.popularMovies,
              title: 'POPULAR MOVIES',
              onNextPage: () => moviesProvider.getOnPopularMovies(),
            ),
            MoviesSlider(
              movies: moviesProvider.topRatedMovies,
              title: 'TOP RATED MOVIES',
              onNextPage: () => moviesProvider.getOnTopRatedMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
