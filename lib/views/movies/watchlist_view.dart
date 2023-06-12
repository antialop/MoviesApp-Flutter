import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/service/auth/auth_service.dart';
import 'package:movies/service/cloud/cloud_favorite.dart';
import 'package:movies/service/cloud/firebase_cloud_storage.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  late final FirebaseCloudStorage _favoriteService;
  final MoviesProvider _moviesProvider = MoviesProvider();

  @override
  void initState() {
    _favoriteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: StreamBuilder<Iterable<CloudFavorite>>(
        stream: _favoriteService.allFavorites(
          ownerUserId: AuthService.firebase().currentUser!.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<CloudFavorite> favoriteMovies = snapshot.data?.toList() ?? [];

          return ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movieId = favoriteMovies.reversed.toList()[index].movieId;

              return FutureBuilder<Movie>(
                future: _moviesProvider.getMovieDetails(movieId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final movie = snapshot.data!;

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      'details',
                      arguments: movie,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            movie.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Image.network(
                            movie.fullPoster,
                            width: 50,
                            height: 50,
                            fit: BoxFit.scaleDown,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () => _deleteFavorite(favoriteMovies
                                .reversed
                                .toList()[index]
                                .documentId),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteFavorite(String documentId) async {
    await _favoriteService.deteleFavorite(documentId: documentId);
  }
}
