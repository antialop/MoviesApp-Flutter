import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/credits_response.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/utilities/dialogs/error_dialog.dart';
import 'package:movies/views/movies/actor_details_view.dart';
import 'package:movies/widgets/icon_favorite.dart';
import 'package:provider/provider.dart';
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
                    CastingCards(movie.id),
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
      backgroundColor: Colors.black,
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
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.black,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: widget.movie.fullPoster != null
                              ? FadeInImage(
                                  placeholder:
                                      const AssetImage('assets/loading.gif'),
                                  image: NetworkImage(widget.movie.fullPoster),
                                  height: 420,
                                )
                              : Image.asset(
                                  'assets/no-image.jpg',
                                  height: 300,
                                ),
                        ),
                        Positioned(
                          top: 10,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
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
                        final videoKey = await _moviesProvider
                            .fetchMovieVideos(widget.movie.id);
                        if (videoKey.isNotEmpty) {
                          // ignore: use_build_context_synchronously
                          playTrailer(videoKey, context);
                        } else {
                          // ignore: use_build_context_synchronously
                          showErrorDialog(context, "No trailer available!");
                        }
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 30)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Watch Trailer'),
                    ),
                    IconFavorite(movie: movie, sizeIcon: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards(this.movieId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder<List<Cast>>(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 100),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30, bottom: 10),
              child: Text(
                'CAST',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
          Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity,
              height: 220,
              child: ListView.builder(
                itemCount: cast.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) => GestureDetector(
                  onTap: () async {
                    final selectedActorId = cast[index].id;
                    final actorDetails = await moviesProvider.getDetailsCast(selectedActorId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActorDetails(actorDetails),
                      ),
                    );
                  },
                  child: _CastCard(cast[index]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard(this.actor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: actor.fullProfilePath != null
                ? FadeInImage(
                    placeholder: const AssetImage("assets/no-image.jpg"),
                    image: NetworkImage(actor.fullProfilePath),
                    height: 140,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/no-image.jpg",
                    height: 140,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            actor.character!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
