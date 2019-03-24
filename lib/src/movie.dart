import 'dart:convert' as json;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:built_value/serializer.dart';
import 'serializers.dart';
import 'dart:convert' as json;

part 'movie.g.dart';

abstract class Movie implements Built<Movie, MovieBuilder> {
  static Serializer<Movie> get serializer => _$movieSerializer;

  int get id;

  @nullable
  String get title;

//  BuiltList<String> get genres;

  String get overview;

  int get runtime;

  String get status;

  String get tagline;

  String get poster_path;

  @nullable
  bool get favorite;

  Movie._();

  factory Movie([updates(MovieBuilder b)]) = _$Movie;
}

List<int> parseRecentMovies(String jsonStr) {
  return List<int>();
//  final parsed = json.jsonDecode(jsonStr);
//  final listOfIds = List<int>.from(parsed);
//
//  return listOfIds;
}

Movie parseMovie(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Movie movie = standartSerializers.deserializeWith(Movie.serializer, parsed);
  return movie;
}

List<Movie> parseMovies(List<String> jsonStr) {
  List<Movie> movies = [];
  for (var i = 0; i < jsonStr.length; i++) {
    final parsed = json.jsonDecode(jsonStr[i]);

    movies.add(standartSerializers.deserializeWith(Movie.serializer, parsed));
  }

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
