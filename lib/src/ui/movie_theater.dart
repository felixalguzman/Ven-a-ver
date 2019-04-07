import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:ven_a_ver/src/movie.dart';
import 'package:ven_a_ver/src/ui/text_style.dart';
import 'package:intl/intl.dart';

class TheaterPage extends StatefulWidget {
  final Movie movie;

  TheaterPage(this.movie);

  @override
  _TheaterPageState createState() => _TheaterPageState();
}

class _TheaterPageState extends State<TheaterPage> {
  final List<String> titulos = ['Santiago', 'Santo Domingo'];
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    print('current $_currentIndex');

    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[_buildPageView(), _buildCircleIndicator()]),
        ],
      ),
    );
  }

  _buildPageView() {
    return Container(
      // color: Colors.black87,
      height: 853.2,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return Material(
            child: Container(
              constraints: BoxConstraints.expand(),
              color: Colors.indigo[800],
              child: Stack(
                children: <Widget>[
                  // _getGradient(),
                  _getContent(context, index),
                  _getToolbar(context),
                ],
              ),
            ),
          );
        },
        itemCount: 2,
        onPageChanged: (int index) {
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: 2,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  Container _getContent(BuildContext context, int num) {
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 63.0, 0.0, 35.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Cine ${titulos[num]}',
                    style: Style.titleTextStyle,
                  )),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            itemCount: num == 0 ? 5 : 7,
            itemBuilder: (context, index) {
              return _listTiles(context, index);
            },
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

  _listTiles(BuildContext context, int num) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 15.0,
      ),
      child: Row(
        children: [
          _ShowtimesInfo(widget.movie, num),
          _DetailedInfo(widget.movie, num),
          _DateInfo(
            movie: widget.movie,
            num: num,
          )
        ],
      ),
    );
  }
}

class _ShowtimesInfo extends StatelessWidget {
  _ShowtimesInfo(this.movie, this.num);
  final Movie movie;
  final int num;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '10:00',
          style: const TextStyle(
            fontSize: 18.0,
            color: const Color(0xFFFEFEFE),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '1${num + 1}:00',
          style: const TextStyle(
            fontSize: 14.0,
            color: const Color(0xFF717DAD),
          ),
        ),
      ],
    );
  }
}

class _DetailedInfo extends StatelessWidget {
  _DetailedInfo(this.movie, this.num);
  final Movie movie;
  final int num;

  @override
  Widget build(BuildContext context) {
    final decoration = const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Color(0xFF717DAD),
        ),
      ),
    );

    final content = [
      Text(
        movie.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          color: const Color(0xFFFEFEFE),
        ),
      ),
      const SizedBox(height: 4.0),
      Text(
        'Sala #${num + 1}',
        style: const TextStyle(
          color: Color(0xFF717DAD),
        ),
      ),
    ];

    return Expanded(
      child: Container(
        decoration: decoration,
        margin: const EdgeInsets.only(left: 12.0),
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final Movie movie;
  final int num;
  static final dateFormat = DateFormat('E');

  _DateInfo({Key key, this.movie, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          dateFormat.format(movie.releaseDate),
          style: TextStyle(
            // fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          movie.releaseDate.day.toString(),
          style: const TextStyle(
            fontSize: 14.0,
            color: const Color(0xFF717DAD),
          ),
        ),
      ],
    );
  }
}
