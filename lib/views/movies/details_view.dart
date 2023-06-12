import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/utilities/dialogs/error_dialog.dart';
import 'package:movies/widgets/icon_favorite.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: Stack(
        children: [
          CustomScrollView(
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
          ),
        ],
      ),
    );
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
                color: Colors.grey,
              ),
      ),
    );
  }
}

class _PosterTitle extends StatefulWidget {
  final Movie movie;

  const _PosterTitle(this.movie);

  @override
  State<_PosterTitle> createState() => _PosterTitleState();
}

class _PosterTitleState extends State<_PosterTitle> {
  final MoviesProvider _moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: widget.movie.fullPoster != null
                  ? FadeInImage(
                      placeholder: const AssetImage('assets/loading.gif'),
                      image: NetworkImage(widget.movie.fullPoster),
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
                  widget.movie.title,
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
                  widget.movie.originalTitle,
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
                    Text('${widget.movie.voteAverage}',
                        style: const TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final videoKey =
                            await _moviesProvider.fetchMovieVideos(widget.movie.id);
                        if (videoKey.isNotEmpty) {
                          // ignore: use_build_context_synchronously
                          playTrailer(videoKey, context);
                        } else {
                          // ignore: use_build_context_synchronously
                          showErrorDialog(context, "No trailer available!");
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(0, 30)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Watch Trailer'),
                    ),
                    Positioned(
                  top: 220,
                  right: 0,
                  child: IconFavorite(movie: movie, sizeIcon: 30),
                ),
                  ],
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }

  void playTrailer(String videoKey, BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
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
