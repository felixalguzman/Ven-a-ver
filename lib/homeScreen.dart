import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/movie_card.dart';
import 'package:ven_a_ver/src/widgets/loading_info.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:ven_a_ver/src/widgets/search.dart';

class HomeScreen extends StatefulWidget {
  final MoviesBloc bloc;

  HomeScreen({Key key, this.bloc}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _appBarTitle = new Text('Ven a ver');
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                showSearch(
                    context: context,
                    delegate: MovieSearch(widget.bloc.movies, widget.bloc));
              },
            )
          ],
          leading: LoadingInfo(widget.bloc.isLoading),
        ),
        body: StreamBuilder<UnmodifiableListView<Movie>>(
          stream: widget.bloc.movies,
          initialData: UnmodifiableListView<Movie>([]),
          builder: ((context, snapshot) => ListView(
                children: snapshot.data
                    .map((m) => MovieSummary(m, widget.bloc))
                    .toList(),
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
                title: Text(
                  'Favoritos',
                  style: _currentIndex == 1
                      ? TextStyle(color: Colors.indigo[800])
                      : TextStyle(color: Colors.grey),
                ),
                icon: Icon(
                  Icons.star,
                  color: _currentIndex == 1
                      ? Colors.orangeAccent
                      : Colors.purpleAccent[800],
                )),
            BottomNavigationBarItem(
                title: Text('Watchlist',
                    style: _currentIndex == 2
                        ? TextStyle(color: Colors.indigo[800])
                        : TextStyle(color: Colors.grey)),
                icon: Icon(Icons.archive,
                    color: _currentIndex == 2
                        ? Colors.blueAccent
                        : Colors.purpleAccent[800]))
          ],
          onTap: (index) {
            if (index == 0) {
              widget.bloc.moviesType.add(TipoPelicula.estreno);
            } else if (index == 1) {
              widget.bloc.moviesType.add(TipoPelicula.favoritos);
            } else if (index == 2) {
              widget.bloc.moviesType.add(TipoPelicula.wishlist);
            }

            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
