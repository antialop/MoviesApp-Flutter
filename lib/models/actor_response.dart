import 'dart:convert';

class ActorResponse {
  bool adult;
  List<String> alsoKnownAs;
  String biography;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String placeOfBirth;
  double popularity;
  String? profilePath;

  ActorResponse({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });
  get fullProfilePath {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    } else {
      'https://i.stack.imgur.com/GNhxO.png';
    }
  }

  factory ActorResponse.fromJson(String str) =>
      ActorResponse.fromMap(json.decode(str));


 factory ActorResponse.fromMap(Map<String, dynamic> json) {
  return ActorResponse(
    adult: json["adult"] ?? false,
    alsoKnownAs: List<String>.from(json["also_known_as"] ?? []),
    biography: json["biography"] ?? "",
    gender: json["gender"] ?? 0,
    id: json["id"] ?? 0,
    knownForDepartment: json["known_for_department"] ?? "",
    name: json["name"] ?? "",
    placeOfBirth: json["place_of_birth"] ?? "",
    popularity: json["popularity"]?.toDouble() ?? 0.0,
    profilePath: json["profile_path"],
  );
}

}
