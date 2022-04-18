import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/newsinfo.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatelessWidget {
  final PostsModel movie;
  final int index;
  var newFormatt = DateFormat("yy-MM-dd");
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';
  MovieDetail({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    String path;
    if (movie.results[index].posterPath != null) {
      path = imgPath + movie.results[index].posterPath;
    } else {
      path = "https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg";
    }
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(movie.results[index].title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            Container(padding: EdgeInsets.all(16), height: height / 1.5, child: Image.network(path)),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(movie.results[index].overview, textAlign: TextAlign.justify, style: TextStyle(fontSize: 16)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Text("Release Date: " + newFormatt.format(movie.results[index].releaseDate)),
            )
          ],
        ))));
  }
}
