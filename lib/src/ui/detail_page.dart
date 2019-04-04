import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/movie_card.dart';
import 'package:ven_a_ver/src/ui/separator.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;
  final MoviesBloc bloc;

  DetailPage(this.movie, this.bloc);

  List<Widget> _buildCategoryChips(TextTheme textTheme) {
    return movie.genres.map((genre) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(genre.name),
          labelStyle: textTheme.caption,
          backgroundColor: Colors.black12,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'movie ${movie.title} date: ${movie.releaseDate} date formatted: ${movie.releaseDateFormatted}');

    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFF736AB7),
        child: Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(context),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getBackground() {
    return Container(
      child: Image(
        image: CachedNetworkImageProvider(movie.backdrop),
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0x00736AB7), Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final _resumenTitle = "Resumen".toUpperCase();
    final _generoTitle = "Géneros".toUpperCase();
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          MovieSummary(
            movie,
            bloc,
            horizontal: false,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _generoTitle,
              style: Style.headerTextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              children: _buildCategoryChips(textTheme),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _resumenTitle,
                  style: Style.headerTextStyle,
                ),
                Separator(),
                Text(movie.overview, style: Style.commonTextStyle),
              ],
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.access_alarms),
                onPressed: () {
                  Flushbar(
                    message:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    icon: Icon(
                      Icons.info_outline,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    aroundPadding: EdgeInsets.all(8),
                    borderRadius: 8,
                    duration: Duration(seconds: 3),
                    leftBarIndicatorColor: Colors.indigo[800],
                  )..show(context);
                }),
          )
        ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BackButton(color: Colors.white),
    );
  }
}
