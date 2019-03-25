import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/separator.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';

Widget movieCardContent(Movie movie) {
  return new Container(
    margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
    constraints: new BoxConstraints.expand(),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(height: 4.0),
        new Text(movie.title, style: Style.titleTextStyle),
        new Container(height: 10.0),
        Container(
//          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            movie.overview,
            style: Style.commonTextStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
          ),
        ),
        Separator()
      ],
    ),
  );
}

Widget movieCard(Movie movie) {
  return new Container(
    child: movieCardContent(movie),
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
        movieCard(movie),
        movieThumbnail(movie),
      ],
    ),
  );
}

Widget movieThumbnail(Movie movie) {
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
