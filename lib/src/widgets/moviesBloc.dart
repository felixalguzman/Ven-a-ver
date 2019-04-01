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

  Sink<Movie> get favoriteMovie => _favoriteMovieController.sink;
  final _favoriteMovieController = StreamController<Movie>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>();

  var _movies = <Movie>[];

  MoviesBloc() {
    _getMoviesAndUpdate(TipoPelicula.estreno);

    _movieTypeController.stream.listen((moviesType) {
      if (moviesType == TipoPelicula.estreno) {
        _getMoviesAndUpdate(moviesType);
      } else if (moviesType == TipoPelicula.favoritos) {
        _getMoviesAndUpdate(moviesType);
      }
    });

    _favoriteMovieController.stream.listen((movie) {
      _markFavorite(movie);
    });
  }

  _getMoviesAndUpdate(TipoPelicula tipo) {
    if (tipo == TipoPelicula.estreno) {
      _trendingMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    } else if (tipo == TipoPelicula.favoritos) {
      _favoriteMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    }
  }



  List<int> _ids = [550, 551, 552, 300];

  Future<Null> _markFavorite(Movie m) async {
    print('movie: ${m.title}');
    _cachedMovies[m.id].favorite = true;

//    _movies = movies;
  }

  Future<Null> _favoriteMovies() async {
    _isLoadingSubject.add(true);

    List<Movie> favorites = [];
    _cachedMovies.forEach((k, x) {
      if (x.favorite) {
        favorites.add(x);
      }
    });

    _isLoadingSubject.add(false);

    _movies = favorites;
  }

  Future<Null> _trendingMovies() async {
    var futureMovies = await _getMovies();
    futureMovies.forEach((m) => _cachedMovies[m.id] = m);
    _movies = futureMovies;
  }

  void close() {
    _moviesSubject.close();
    _isLoadingSubject.close();
    _movieTypeController.close();
    _favoriteMovieController.close();
  }

  Future<Movie> _getMovie(int id) async {
    if (!_cachedMovies.containsKey(id)) {
      _isLoadingSubject.add(true);

      final movieUrl =
          'https://api.themoviedb.org/3/movie/$id?api_key=${TMDBConfig.apiKey}';
      final movieRes = await http.get(movieUrl);

      if (movieRes.statusCode == 200) {
        Map json = jsonDecode(movieRes.body);
        _cachedMovies[id] = Movie.fromJson(json);
        _isLoadingSubject.add(false);
      } else {
        throw MovieApiError("Movie $id no se pudo buscar");
      }
    }

    return _cachedMovies[id];
  }

  Future<List<Movie>> _getMovies() async {
    _isLoadingSubject.add(true);

    final movieUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=${TMDBConfig.apiKey}';
    final movieRes = await http.get(movieUrl);

    if (movieRes.statusCode == 200) {
      _isLoadingSubject.add(false);

      return parseMovies(movieRes.body);
    }

    throw MovieApiError("Movies trending no se pudo buscar");
  }
}

enum TipoPelicula { estreno, favoritos }
