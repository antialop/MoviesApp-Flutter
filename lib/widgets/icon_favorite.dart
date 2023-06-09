import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/service/auth/auth_service.dart';
import 'package:movies/service/cloud/cloud_favorite.dart';
import 'package:movies/service/cloud/firebase_cloud_storage.dart';

class IconFavorite extends StatefulWidget {
  final Movie movie;
  final double sizeIcon;
  const IconFavorite({super.key, required this.movie, this.sizeIcon = 20});

  @override
  State<IconFavorite> createState() => _IconFavoriteState();
}

class _IconFavoriteState extends State<IconFavorite> {

  Stream<Iterable<CloudFavorite>>? _favoritesStream;
  late final FirebaseCloudStorage _favoriteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _favoriteService = FirebaseCloudStorage();
    _favoritesStream = _favoriteService.allFavorites(ownerUserId: userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Iterable<CloudFavorite>>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          final isFavorite = snapshot.hasData &&
              snapshot.data!.any((fav) => fav.movieId == widget.movie.id);
          return IconButton(
            onPressed: () {
              tooggleFavorite(widget.movie);
              setState(() {
                widget.movie.isFavorite = !isFavorite;
              });
            },
            icon: favoriteIcon(isFavorite),
            iconSize: widget.sizeIcon,
          );
        },
      ),
    );
  }

  void tooggleFavorite(Movie movie) async {
    final favoriteMovies =
        await _favoriteService.getFavoritesMovies(ownerUserId: userId);

    for (var fav in favoriteMovies) {
      if (fav.movieId == movie.id) {
        await _favoriteService.deteleFavorite(documentId: fav.documentId);
        return;
      }
    }
    await _favoriteService.newFavoriteMovie(
        ownerUserId: userId, movieId: movie.id);
  }

  Widget favoriteIcon(bool isFavorite) {
    if (isFavorite) {
      return const Icon(
        Icons.bookmark,
        color: Colors.yellow,
      );
    }
    return const Icon(
      Icons.bookmark,
      color: Colors.white,
    );
  }
}
