
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
    movies.add(Movie.fromJson(resultados[i]));
  }



  return movies;
}


