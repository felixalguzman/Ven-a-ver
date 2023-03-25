import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/detail_page.dart';
import 'package:ven_a_ver/src/ui/separator.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';

class MovieSummary extends StatefulWidget {
  final Movie movie;
  final bool horizontal;
  final MoviesBloc? bloc;

  MovieSummary(this.movie, this.bloc, {Key? key, this.horizontal = true});

  MovieSummary.vertical(this.movie, this.bloc) : horizontal = false;

  @override
  _MovieSummaryState createState() => _MovieSummaryState();
}

class _MovieSummaryState extends State<MovieSummary> {
  late bool favorite;
  late bool wishlist;
  String? title;

  @override
  void initState() {
    super.initState();

    favorite = widget.movie.favorite;
    wishlist = widget.movie.wishlist;
    title = widget.movie.title;
    print('id: ${widget.movie.title}');
  }

  @override
  Widget build(BuildContext context) {
    final movieThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: widget.horizontal
          ? FractionalOffset.centerLeft
          : FractionalOffset.center,
      child: Hero(
        tag: "movie-hero-${widget.movie.title}",
        child: Image(
          image: CachedNetworkImageProvider(widget.movie.posterImageUrl),
          height: 150.0,
          width: 100.0,
        ),
      ),
    );

    final movieCardContent = Container(
      margin: EdgeInsets.fromLTRB(widget.horizontal ? 76.0 : 16.0,
          widget.horizontal ? 16.0 : 42.0, 16.0, 20.0),
      constraints: BoxConstraints.expand(height: 200.0),
      child: Column(
        crossAxisAlignment: widget.horizontal
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Text(
            widget.movie.title!,
            style: Style.titleTextStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
          ),
          Container(height: 10.0),
          Container(
//          padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
              widget.movie.overview!,
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
                      itemBuilder: (context, index) => ItemList(
                          widget.horizontal
                              ? widget.movie.genres[index].name
                              : widget.movie.autores[index]),
                      itemCount: widget.horizontal
                          ? widget.movie.genres.length
                          : widget.movie.autores.length),
                ),
              ),
              (widget.horizontal ? Text('') : movieReleasedDate(widget.movie))
            ],
          ),
        ],
      ),
    );

    final movieCard = Container(
      child: movieCardContent,
      height: widget.horizontal ? 124.0 : 160.0,
      margin: widget.horizontal
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
      onTap: widget.horizontal
          ? () => Navigator.of(context).push(
                new PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      DetailPage(widget.movie, widget.bloc),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                ),
              )
          : null,
      child: Slidable(
          // delegate: SlidableDrawerDelegate(),
          // actionExtentRatio: 0.25,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.horizontal ? 20.0 : 30.0,
              horizontal: 24.0,
            ),
            child: Stack(
              children: <Widget>[movieCard, movieThumbnail],
            ),
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: <Widget>[
              StreamBuilder<UnmodifiableListView<Movie>>(
                stream: widget.bloc!.movies,
                builder: ((context, snapshot) => SlidableAction(
                      label: favorite ? 'Unfavorite' : 'Favorite',
                      backgroundColor: Colors.orangeAccent,
                      icon: favorite ? Icons.star : Icons.star_border,
                      onPressed: (context) {
                        print('movie ${widget.movie.title}');
                        widget.bloc!.favoriteMovie.add(title);

                        setState(() {
                          favorite = !favorite;
                        });
                      },
                    )),
              ),
              SlidableAction(
                label: wishlist ? 'Unwatchlist' : 'Watchlist',
                backgroundColor: Colors.blueAccent,
                icon: wishlist ? Icons.unarchive : Icons.archive,
                onPressed: (context) {
                  widget.bloc!.wishlistMovie.add(title);
                  setState(() {
                    wishlist = !wishlist;
                  });
                },
              )
            ],
          )),
    );
  }
}

class ItemList extends StatelessWidget {
  ItemList(this.nombre);

  final String? nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            nombre!,
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
      Icon(
        Icons.date_range,
        color: Colors.white,
      ),
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
