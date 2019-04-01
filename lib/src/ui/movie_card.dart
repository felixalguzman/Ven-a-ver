import 'package:flutter/material.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/detail_page.dart';
import 'package:ven_a_ver/src/ui/separator.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieSummary extends StatelessWidget {
  final Movie movie;
  final bool horizontal;

  MovieSummary(this.movie, {this.horizontal = true});

  MovieSummary.vertical(this.movie) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    final movieThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "movie-hero-${movie.title}",
        child: Image(
          image: CachedNetworkImageProvider(movie.posterImageUrl),
          height: 150.0,
          width: 100.0,
        ),
      ),
    );

    final movieCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 20.0),
      constraints: BoxConstraints.expand(height: 200.0),
      child: Column(
          crossAxisAlignment:
              horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 4.0),
            Text(
              movie.title,
              style: Style.titleTextStyle,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
            ),
            Container(height: 10.0),
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
            Separator(),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 18,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ItemList(horizontal
                            ? movie.genres[index].name
                            : movie.autores[index]),
                        itemCount: horizontal
                            ? movie.genres.length
                            : movie.autores.length),
                  ),
                ),
                (horizontal ? Text('') : movieReleasedDate(movie))
              ],
            )
          ]),
    );

    final movieCard = Container(
      child: movieCardContent,
      height: horizontal ? 124.0 : 160.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 130.0),
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

    return GestureDetector(
      onTap: horizontal
          ? () => Navigator.of(context).push(
                new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DetailPage(movie),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                ),
              )
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: horizontal ? 20.0 : 30.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: <Widget>[movieCard, movieThumbnail],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  ItemList(this.nombre);

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            nombre,
            style: Style.smallTextStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
//      textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Widget movieReleasedDate(Movie movie) {
  return Row(
    children: <Widget>[
      Icon(Icons.date_range, color: Colors.white,),
      Text(
        movie.releaseDateFormatted,
        style: Style.commonTextStyle,
      )
    ],
  );
}

List<Widget> itemList(List<String> valores) {
  List<Widget> items = [];

  for (var i = 0; i < valores.length; i++) {
    items.add(Text(
      valores[i],
      style: Style.smallTextStyle,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: 1,
//      textAlign: TextAlign.center,
    ));
  }

  return items;
}
