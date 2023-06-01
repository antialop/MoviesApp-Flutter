import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/models/popular_movie.dart';

class MoviesProvider extends ChangeNotifier {
  final String _url = 'api.themoviedb.org';
  final String _apiKey = 'b936c27b6e612129ff7431efaa136319';
  final String _language = 'en-US';

  List<PopularMovie> popularMovies = [];

  MoviesProvider() {
    getOnPopularMovies();
  }

  getOnPopularMovies() async {
    var url = Uri.https(
        _url, '3/movie/popular', {'language': _language, 'api_key': _apiKey});
    final response = await http.get(url);
    final moviesResponse = MoviesResponse.fromJson(response.body);
    popularMovies = moviesResponse.results;
    notifyListeners();
  }
}
