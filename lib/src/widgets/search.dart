import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/movie_card.dart';

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
      builder: (context, AsyncSnapshot<UnmodifiableListView<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            'No data!',
          ));
        }

        var results = snapshot.data.where((a) =>
            a.title.toLowerCase().contains(query.toLowerCase()) ||
            a.overview.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results.map((m) => MovieSummary(m)).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder<UnmodifiableListView<Movie>>(
      stream: movies,
      builder: (context, AsyncSnapshot<UnmodifiableListView<Movie>> snapshot) {
        if (query.isEmpty) {
          return Center(
              child: Text(
            '',
          ));
        }

        final results = snapshot.data.where((a) =>
            a.title.toLowerCase().contains(query.toLowerCase()) ||
            a.genres.any(
                (g) => g.name.toLowerCase().contains(query.toLowerCase())) ||
            a.overview.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results.map((m) => MovieSummary(m)).toList(),
        );
      },
    );
  }
}
