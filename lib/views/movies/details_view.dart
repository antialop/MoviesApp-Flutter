import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
        body: CustomScrollView(
          slivers: [
            _CustomAppBar(movie),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _PosterTitle(movie),
                  _Overview(movie),
                ],
              ),
            ),
          ],
        ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Text(
            movie.title,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
            background: movie.fullBackdropPath != null
          ? FadeInImage(
              placeholder: const AssetImage("assets/loading.gif"),
              image: NetworkImage(movie.fullBackdropPath),
              fit: BoxFit.cover,
            )
          : Container(
              color: Colors.grey, // Color de respaldo si no hay backdropPath
            ),
      ),
    );
  }
}

class _PosterTitle extends StatelessWidget {
  final Movie movie;

  const _PosterTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: movie.fullPoster != null
              ? FadeInImage(
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: NetworkImage(movie.fullPoster),
                  height: 150,
                )
              : Image.asset(
                  'assets/no-image.jpg',
                  height: 150,
                ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  movie.originalTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('${movie.voteAverage}',
                        style: const TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.bookmark,
                        size: 35,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
