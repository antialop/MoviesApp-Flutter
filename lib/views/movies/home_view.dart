import 'package:flutter/material.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/widgets/popular_movies_slider.dart';
import 'package:movies/widgets/top_rated_movies.dart';
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
            PopularMoviesSlider(
              movies: moviesProvider.popularMovies,
              title: 'POPULAR MOVIES',
            ),
             TopRatedMoviesSlider(
              movies: moviesProvider.topRatedMovies,
              title: 'TOP RATED MOVIES',
            ),
          ],
        ),
      ),
    );
  }
}
