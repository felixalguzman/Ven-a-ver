import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/movie_card.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:ven_a_ver/src/widgets/search.dart';

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
                children: snapshot.data.map(card).toList(),
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
}
