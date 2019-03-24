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
  Stream<List<Movie>> get movies => _moviesSubject.stream;

  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  var _movies = <Movie>[];

  MoviesBloc() {
    _updateMovies().then((_) {
      _moviesSubject.add(UnmodifiableListView(_movies));
    });
  }

  List<int> _ids = [550, 551, 552, 300];

  Future<Null> _updateMovies() async {
    final futureMovies = _ids.map((id) => _getMovie(id));
    final movies = await Future.wait(futureMovies);
    _movies = movies;
  }

  Future<Movie> _getMovie(int id) async {
    final movieUrl =
        'https://api.themoviedb.org/3/movie/${id}?api_key=${TMDBConfig.apiKey}';
    final movieRes = await http.get(movieUrl);

    if (movieRes.statusCode == 200) {
      return parseMovie(movieRes.body);
    }
  }
}
