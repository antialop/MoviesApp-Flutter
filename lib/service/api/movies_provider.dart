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
  int _popularPage = 0;
  int _topRatedPage = 0;

  MoviesProvider() {
    getOnPopularMovies();
    getOnTopRatedMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_url, endpoint, {
      'page': '$page',
      'language': _language,
      'api_key': _apiKey,
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = MoviesResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  getOnTopRatedMovies() async {
    _topRatedPage++;
    final jsonData = await _getJsonData('3/movie/top_rated', _topRatedPage);
    final topRatedResponse = MoviesResponse.fromJson(jsonData);
    topRatedMovies = [...topRatedMovies, ...topRatedResponse.results];
    notifyListeners();
  }
}
