import 'dart:convert' as json;

import 'dart:convert';

class Movie {
  int id;

  String title;

//  BuiltList<String> get genres;

  String overview;

  int runtime;

  String status;

  String tagline;

  String posterImageUrl;

  bool favorite;

  Movie.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        overview = json['overview'],
        runtime = json['runtime'],
        status = json['status'],
        tagline = json['tagLine'],
        posterImageUrl =
            'http://image.tmdb.org/t/p/w400/' + json['poster_path'];
}

List<Movie> parseMovies(String jsonStr) {
  List<Movie> movies = [];
  var array = jsonDecode(jsonStr);

  List resultados = array['results'];

  for (var i = 0; i < resultados.length; i++) {
    print('mov: ${resultados[i]}');

    movies.add(Movie.fromJson(resultados[i]));
  }

//  print(resultados[0]['adult'] + ' len ${resultados.length}' );

  print(movies);
//  movies.insertAll(0, List<Movie>.from(array['results'][1]));

  return movies;
}

//import 'dart:convert' as json;
//
//class Movie {
//  String title;
//  List<String> genres;
//  int id;
//  String overview;
//  int runtime;
//  String status;
//  String tagline;
//  String posterUrl;
//
//  Movie({this.title, this.genres, this.id, this.overview, this.runtime,
//      this.status, this.tagline, this.posterUrl});
//
//  factory Movie.fromJson(Map<String, dynamic> json) {
//    if (json == null) {
//      return null;
//    }
//
//    return Movie(
//        title: json['title'] ?? "null",
//        genres: json['genres'],
//        id: json['id'],
//        overview: json['overview'],
//        runtime: json['runtime'],
//        status: json['status'],
//        tagline: json['tagline'],
//        posterUrl: json['poster']
//    );
//  }
//
////  Movie parseMovie(String jsonStr) {
////    var parsed = json.jsonDecode(jsonStr);
////    var movie = Movie('demo', [''], 0, "", 0, "", "", "");
////    // var article = standardSerializers.deserializeWith(Movie.serializer, parsed);
////    return movie;
////  }
//}
