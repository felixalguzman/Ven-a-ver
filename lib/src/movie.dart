import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:ven_a_ver/src/genres.dart';

class Movie {
  int id;

  String title;

//  BuiltList<String> get genres;

  String overview;

  int runtime;

  String status;

  String tagline;

  String posterImageUrl;

  String backdrop;

  DateTime releaseDate;

  List<String> autores = ['Oscar', 'Karvin', 'Miguel', 'Omar'];

  List<Genres> genres;

  bool favorite;

  Movie.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        overview = json['overview'],
        runtime = json['runtime'],
        status = json['status'],
        tagline = json['tagLine'],
        posterImageUrl =
            'http://image.tmdb.org/t/p/w400/' + json['poster_path'],
        releaseDate = DateTime.parse(json['release_date']),
        genres = parseGenres(json['genre_ids']),
        backdrop = 'http://image.tmdb.org/t/p/w400/' + json['backdrop_path'];

  String get releaseDateFormatted {
    return formatDate(releaseDate, [dd, '-', mm, '-', yyyy]);
  }
}

List<Movie> parseMovies(String jsonStr) {
  List<Movie> movies = [];
  var array = jsonDecode(jsonStr);

  List resultados = array['results'];

  for (var i = 0; i < resultados.length; i++) {
    print('${resultados[i]}');
    movies.add(Movie.fromJson(resultados[i]));
  }

  return movies;
}
