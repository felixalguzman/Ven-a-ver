import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:ven_a_ver/src/widgets/search.dart';
import 'package:auto_size_text/auto_size_text.dart';
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


  Widget planetCardContent(Movie movie) {
    return new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(movie.title, style: Style.titleTextStyle),
          new Container(height: 10.0),
          AutoSizeText(
            movie.overview,
            maxLines: 2,
            style: Style.commonTextStyle,
          ),
        ],
      ),
    );
  }

  Widget planetCard(Movie movie) {
    return new Container(
      child: planetCardContent(movie),
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  Widget card(Movie movie) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          planetCard(movie),
          planetThumbnail(movie),
        ],
      ),
    );
  }

  Widget planetThumbnail(Movie movie) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Container(
//        tag: "movie-${movie.id}",
        child: Image.network(
          movie.posterImageUrl,
          height: 120.0,
          width: 100.0,
        ),
      ),
    );
  }
}
