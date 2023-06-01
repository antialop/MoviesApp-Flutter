import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie_response.dart';
import 'package:movies/models/movie.dart';

class MoviesProvider extends ChangeNotifier {
  final String _url = 'api.themoviedb.org';
  final String _apiKey = 'b936c27b6e612129ff7431efaa136319';
  final String _language = 'en-US';

  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];

  MoviesProvider() {
    getOnPopularMovies();
    getOnTopRatedMovies();
  }

  getOnPopularMovies() async {
    var url = Uri.https(
        _url, '3/movie/popular', {'language': _language, 'api_key': _apiKey});
    final response = await http.get(url);
    final moviesResponse = MoviesResponse.fromJson(response.body);
    popularMovies = moviesResponse.results;
    notifyListeners();
  }
    getOnTopRatedMovies() async {
    var url = Uri.https(
        _url, '3/movie/top_rated', {'language': _language, 'api_key': _apiKey});
    final response = await http.get(url);
    final moviesResponse = MoviesResponse.fromJson(response.body);
    topRatedMovies = moviesResponse.results;
    notifyListeners();
  }
}
