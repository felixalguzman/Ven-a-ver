import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:ven_a_ver/src/widgets/search.dart';
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
  int _currentIndex = 0;

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
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                title: Text(
                  'Populares',
                ),
                icon: Icon(Icons.new_releases)),
            BottomNavigationBarItem(
                title: Text('Otros'), icon: Icon(Icons.movie))
          ],
          onTap: (index) {
            if (index == 0) {
              widget.bloc.moviesType.add(TipoPelicula.estreno);
            } else {
              widget.bloc.moviesType.add(TipoPelicula.favoritos);
            }

            setState(() {
              _currentIndex = index;
            });
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
            Image.network(movie.posterImageUrl),
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
