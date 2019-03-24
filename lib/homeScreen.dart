import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:ven_a_ver/tmdb_config.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final MoviesBloc bloc;

  HomeScreen({Key key, this.bloc}) : super(key: key);

  // ExamplePage({ Key key }) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _appBarTitle = new Text('Ven a ver');

  Widget build(BuildContext context) {
    List<Movie> _movies = [];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var result = await showSearch(
                    context: context, delegate: MovieSearch(null));
              },
            )
          ],
        ),
        body: StreamBuilder<UnmodifiableListView<Movie>>(
          stream: widget.bloc.movies,
          initialData: UnmodifiableListView<Movie>([]),
          builder: ((context, snapshot) => ListView(
                children: snapshot.data.map(_buildItem).toList(),
              )),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                title: Text(
                  'Populares',
                  style: TextStyle(color: Colors.grey),
                ),
                icon: IconTheme(
                    data: IconThemeData(color: Colors.grey[700]),
                    child: Icon(Icons.new_releases))),
            BottomNavigationBarItem(
                title: Text('Otros'), icon: Icon(Icons.movie))
          ],
          onTap: (index) {
            if (index == 0) {
              print('populares');
            } else {
              print('otros');
            }
          },
        ));
  }

  Widget _buildItem(Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(movie.title ?? 'no tiene'),
              subtitle: Text(movie.overview),
            )
          ],
        ),
      ),
    );
  }
}

Future<Movie> _searchByName(String text) async {
  // ignore: unnecessary_brace_in_string_interps
  final movieUrl =
      'https://api.themoviedb.org/3/movie?/search?query=${text}?api_key=${TMDBConfig.apiKey}';
  final movieRes = await http.get(movieUrl);

  if (movieRes.statusCode == 200) {
    return parseMovie(movieRes.body);
  }
}

class MovieSearch extends SearchDelegate<Movie> {
  final UnmodifiableListView<Movie> movies;

  MovieSearch(this.movies);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return Text(query);
  }
}
