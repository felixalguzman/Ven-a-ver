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
  HashMap<String, Movie> _cachedMovies = HashMap<String, Movie>();

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  Sink<TipoPelicula> get moviesType => _movieTypeController.sink;
  final _movieTypeController = StreamController<TipoPelicula>();

  Sink<String> get favoriteMovie => _favoriteMovieController.sink;
  final _favoriteMovieController = StreamController<String>();

  Sink<String> get wishlistMovie => _wishlistMovieController.sink;
  final _wishlistMovieController = StreamController<String>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>();

  var _movies = <Movie>[];

  MoviesBloc() {
    _getMoviesAndUpdate(1);

    _movieTypeController.stream.listen((moviesType) {
      if (moviesType == TipoPelicula.estreno) {
        _getMoviesAndUpdate(1);
      } else if (moviesType == TipoPelicula.favoritos) {
        _getMoviesAndUpdate(2);
      } else if (moviesType == TipoPelicula.wishlist) {
        _getMoviesAndUpdate(3);
      }
    });

    _favoriteMovieController.stream.listen((title) {
      _markFavorite(title);
    });

    _wishlistMovieController.stream.listen((title) {
      _markWishlist(title);
    });


  }

  _getMoviesAndUpdate(int x) {
    if (x == 1) {
      _trendingMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    } else if (x == 2) {
      _favoriteMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    } else if (x == 3) {
      _wishlistMovies().then((_) {
        _moviesSubject.add(UnmodifiableListView(_movies));
      });
    }
  }

  Future<Null> _markFavorite(String m) async {
    _cachedMovies.forEach((k, v) {
      var o = v;

      print('fav id: $m otros: ${o.id}');
      if (m.toLowerCase() == o.title.toLowerCase()) {
//        print('fav movie: ${o.title}');

        o.favorite = !o.favorite;
        _cachedMovies[k] = o;
      }
    });
  }

  Future<Null> _markWishlist(String m) async {
    _cachedMovies.forEach((k, v) {
      var o = v;

      print('fav id: $m otros: ${o.id}');
      if (m.toLowerCase() == o.title.toLowerCase()) {
//        print('fav movie: ${o.title}');

        o.wishlist = !o.wishlist;
        _cachedMovies[k] = o;
      }
    });
  }


  Future<Null> _favoriteMovies() async {
    _isLoadingSubject.add(true);

    List<Movie> favs = [];
    _cachedMovies.forEach((k, v) {
      if (v != null) {
        if (v.favorite) {
          print('movie  ${v.title}');

          favs.add(v);
        }
      }
    });

    _isLoadingSubject.add(false);

    _movies = favs;
  }

  Future<Null> _wishlistMovies() async {
    _isLoadingSubject.add(true);

    List<Movie> wish = [];
    _cachedMovies.forEach((k, v) {
      if (v != null) {
        if (v.wishlist) {
          print('movie  ${v.title}');

          wish.add(v);
        }
      }
    });

    _isLoadingSubject.add(false);

    _movies = wish;
  }

  Future<Null> _trendingMovies() async {
    var futureMovies = await _getMovies();
    futureMovies.forEach((m) {
      if (!_cachedMovies.containsKey(m.title)) {
        _cachedMovies[m.title] = m;
      }
    });

    _movies = _cachedMovies.values.toList();
  }

  void close() {
    _moviesSubject.close();
    _isLoadingSubject.close();
    _movieTypeController.close();
    _favoriteMovieController.close();
    _wishlistMovieController.close();
  }

  Future<Movie> _getMovie(int id) async {
    if (!_cachedMovies.containsKey(id)) {
      _isLoadingSubject.add(true);

      final movieUrl =
          'https://api.themoviedb.org/3/movie/$id?api_key=${TMDBConfig.apiKey}';
      final movieRes = await http.get(Uri.parse(movieUrl));

      if (movieRes.statusCode == 200) {
        Map json = jsonDecode(movieRes.body);
        _cachedMovies[Movie.fromJson(json).title] = Movie.fromJson(json);
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
    final movieRes = await http.get(Uri.parse(movieUrl));

    if (movieRes.statusCode == 200) {
      _isLoadingSubject.add(false);

      return parseMovies(movieRes.body);
    }

    throw MovieApiError("Movies trending no se pudo buscar");
  }
}

enum TipoPelicula { estreno, favoritos, wishlist }
