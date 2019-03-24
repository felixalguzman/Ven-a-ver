import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';

class HomeScreen extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget _appBarTitle = new Text('Ven a ver');




  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var result =
              await showSearch(context: context, delegate: MovieSearch(null));
            },
          )
        ],
      ),
      body: Container(
//        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }



}

class MovieSearch extends SearchDelegate<Movie> {

final UnmodifiableListView<Movie> movies;

  MovieSearch(this.movies);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = '';
    })];
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
