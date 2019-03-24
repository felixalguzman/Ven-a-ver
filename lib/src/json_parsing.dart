import 'dart:convert' as json;

import 'package:built_value/built_value.dart';
import 'package:ven_a_ver/Movie.dart';

import 'dart:convert' as json;

part 'json_parsing.g.dart';

abstract class Movie implements Built<Movie, MovieBuilder> {

  int get id;


  Movie._();
  factory Movie([updates(MovieBuilder b)]) = _$Movie;
}
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
//  Movie(
//      {this.title,
//      this.genres,
//      this.id,
//      this.overview,
//      this.runtime,
//      this.status,
//      this.tagline,
//      this.posterUrl});
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
//        posterUrl: json['poster']);
//  }

//  Movie parseMovie(String jsonStr) {
//    var parsed = json.jsonDecode(jsonStr);
//    var movie = Movie('demo', [''], 0, "", 0, "", "", "");
//    // var article = standardSerializers.deserializeWith(Movie.serializer, parsed);
//    return movie;
//  }
//}

List<int> parseRecentMovies(String jsonStr) {
  return List<int>();
//  final parsed = json.jsonDecode(jsonStr);
//  final listOfIds = List<int>.from(parsed);
//
//  return listOfIds;
}

Movie parseMovie(String jsonStr) {
  return null;
//  final parsed = json.jsonDecode(jsonStr);
//  Movie movie = Movie.fromJson(parsed);
//  return movie;
}
