import 'dart:convert';
import 'package:movies/models/popular_movie.dart';

class MoviesResponse {
    int page;
    List<PopularMovie> results;
    int totalPages;
    int totalResults;

    MoviesResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory MoviesResponse.fromJson(String str) => MoviesResponse.fromMap(json.decode(str));

    factory MoviesResponse.fromMap(Map<String, dynamic> json) => MoviesResponse(
        page: json["page"],
        results: List<PopularMovie>.from(json["results"].map((x) => PopularMovie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}






