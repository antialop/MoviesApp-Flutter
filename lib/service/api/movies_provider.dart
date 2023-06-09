import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie_response.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _url = 'api.themoviedb.org';
  final String _apiKey = 'b936c27b6e612129ff7431efaa136319';
  final String _language = 'en-US';

  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> upcomingMovies = [];
  int _popularPage = 0;
  int _topRatedPage = 0;
  int _upcomingPage = 0;

  MoviesProvider() {
    getOnPopularMovies();
    getOnTopRatedMovies();
    getOnUpcomingMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_url, endpoint, {
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
    getOnUpcomingMovies() async {
    _upcomingPage++;
    final jsonData = await _getJsonData('3/movie/upcoming', _upcomingPage);
    final topUpcomingResponse = MoviesResponse.fromJson(jsonData);
    upcomingMovies = [...upcomingMovies, ...topUpcomingResponse.results];
    notifyListeners();
  }


  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId', {
      'language': _language,
      'api_key': _apiKey,
    });
    final response = await http.get(url);
    final detailsMovie = Movie.fromJson(response.body);
    return detailsMovie;
   
  }
}
