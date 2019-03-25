import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';

class MovieSearch extends SearchDelegate<Movie> {

  final Stream<UnmodifiableListView<Movie>> movies;

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
    return StreamBuilder<UnmodifiableListView<Movie>>(
      stream: movies,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
                'No data!',
              ));
        }

        var results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
            title: Text(a.title,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontSize: 16.0)),
            leading: Icon(Icons.book),
            onTap: () async {
//              if (await canLaunch(a.url)) {
//                await launch(a.url);
//              }
              close(context, a);
            },
          ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return StreamBuilder<UnmodifiableListView<Movie>>(
      stream: movies,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
                'No data!',
              ));
        }

        final results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
            title: Text(a.title,
                style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: 16.0,
                  color: Colors.blue,
                )),
            onTap: () {
              close(context, a);
            },
          ))
              .toList(),
        );
      },
    );
  }
}
