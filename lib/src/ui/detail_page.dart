import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/movie_card.dart';
import 'package:ven_a_ver/src/ui/movie_theater.dart';
import 'package:ven_a_ver/src/ui/separator.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';
import 'package:share/share.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;
  final MoviesBloc bloc;

  DetailPage(this.movie, this.bloc);

  List<Widget> _buildCategoryChips() {
    return movie.genres.map((genre) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(genre.name),
          labelStyle: TextStyle(color: Colors.indigo[800]),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: IconButton(
                    icon: Icon(
                      Icons.access_alarms,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      Flushbar(
                        title: movie.title,
                        message:
                            'Serás notificado de cualquier actualización sobre esta película.',
                        icon: Icon(
                          Icons.new_releases,
                          size: 28.0,
                          color: Colors.white,
                        ),
                        
                        padding: EdgeInsets.all(8),
                        borderRadius: 8,
                        duration: Duration(seconds: 3),
                        leftBarIndicatorColor: new Color(0xff00c6ff),
                      )..show(context);
                    }),
              ),
              Container(
                  child: TextButton.icon(
                icon: Icon(
                  Icons.movie,
                  color: Colors.redAccent[200],
                ),
                label: Text(
                  'Cartelera',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).push(
                      new PageRouteBuilder(
                        pageBuilder: (_, __, ___) => TheaterPage(movie),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                new FadeTransition(
                                    opacity: animation, child: child),
                      ),
                    ),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Share.share(movie.title + ' ' + movie.movieURL);
                    }),
              )
            ],
          ),
          SizedBox(
            height: 2,
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
              children: _buildCategoryChips(),
            ),
          ),
          SizedBox(
            height: 20,
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
