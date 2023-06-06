import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _emptyContainer() {
    return Container(
      color:  const Color.fromARGB(255, 22, 22, 22),
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.white,
          size: 130,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    if (query.isEmpty) {
      return _emptyContainer();
    }
    return Container(
      color: Colors.black,
      child: FutureBuilder(
        future: moviesProvider.searchMovies(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) => _MovieItem(movies[index]));
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    if (query.isEmpty) {
      return _emptyContainer();
    }
    return Container(
      color: Colors.black,
      child: FutureBuilder(
        future: moviesProvider.searchMovies(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) => _MovieItem(movies[index]));
        },
      ),
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    String posterUrl = movie.fullPoster ?? '';

    // Verificar si no hay URL de póster y usar imagen por defecto
    if (posterUrl.isEmpty) {
      return ListTile(
        leading: Image.asset(
          'assets/no-image.jpg',
          width: 50,
          fit: BoxFit.contain,
        ),
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          movie.originalTitle,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () {
          Navigator.pushNamed(context, "details", arguments: movie);
        },
      );
    }

    return ListTile(
      leading: FadeInImage(
        placeholder: const AssetImage('assets/no-image.jpg'),
        image: NetworkImage(posterUrl),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(
        movie.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        movie.originalTitle,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pushNamed(context, "details", arguments: movie);
      },
    );
  }
}
