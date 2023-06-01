import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';

class TopRatedMoviesSlider extends StatelessWidget {
  final List<Movie> movies;
  final String? title;

  const TopRatedMoviesSlider({super.key, required this.movies, this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left:20,bottom: 5),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,                      
                ),
              
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (_, int index) => TopRatedMovies(movies[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class TopRatedMovies extends StatelessWidget {
  final Movie movie;

  const TopRatedMovies(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPoster),
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
             style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,                    
                ),
          ),
        ],
      ),
    );
  }
}
