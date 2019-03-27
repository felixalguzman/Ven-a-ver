import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ven_a_ver/src/movie.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:ven_a_ver/tmdb_config.dart';

class MovieApiError extends Error {
  final String message;

  MovieApiError(this.message);
}

class MoviesBloc {
  HashMap<int, Movie> _cachedMovies = HashMap<int, Movie>();

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  Sink<TipoPelicula> get moviesType => _movieTypeController.sink;
  final _movieTypeController = StreamController<TipoPelicula>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>();

  var _movies = <Movie>[];

  MoviesBloc() {
    _getMoviesAndUpdate(1);

    _movieTypeController.stream.listen((moviesType) {
      if (moviesType == TipoPelicula.estreno) {
        _getMoviesAndUpdate(1);
      } else {
        _getMoviesAndUpdate(0);
      }
    });
  }

  _getMoviesAndUpdate(int type) {
    if (type == 1) {
      _trendingMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    } else {
      _fixedMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    }
  }

  List<int> _ids = [550, 551, 552, 300];

  Future<Null> _fixedMovies() async {
    final futureMovies = _ids.map((id) => _getMovie(id));
    final movies = await Future.wait(futureMovies);
    _movies = movies;
  }

  Future<Null> _trendingMovies() async {
    var futureMovies = await _getMovies();
    _movies = futureMovies;
  }

  void close(){
    _moviesSubject.close();
    _isLoadingSubject.close();
    _movieTypeController.close();
  }

  Future<Movie> _getMovie(int id) async {
    final movieUrl =
        'https://api.themoviedb.org/3/movie/$id?api_key=${TMDBConfig.apiKey}';
    final movieRes = await http.get(movieUrl);

    if (movieRes.statusCode == 200) {
      Map json = jsonDecode(movieRes.body);
      Movie m = Movie.fromJson(json);
      return m;
    }

    throw MovieApiError("Movie $id no se pudo buscar");
  }

  Future<List<Movie>> _getMovies() async {
    final movieUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=${TMDBConfig.apiKey}';
    final movieRes = await http.get(movieUrl);

    if (movieRes.statusCode == 200) {
      return parseMovies(movieRes.body);
    }

    throw MovieApiError("Movies trending no se pudo buscar");
  }
}

enum TipoPelicula { estreno, favoritos }
