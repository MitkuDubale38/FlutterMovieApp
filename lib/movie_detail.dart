import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/newsinfo.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatelessWidget {
  final PostsModel movie;
  final int index;
  var newFormatt = DateFormat("dd-MM-yy");
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
        child: Column(
          children: <Widget>[
            Hero(
              tag: movie.results[index].title,
              child: Center(
                child: Column(children: [
                  Container(padding: EdgeInsets.all(16), height: height / 1.5, child: Image.network(path)),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overview", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(movie.results[index].voteAverage.toString() + "⭐", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(movie.results[index].overview, textAlign: TextAlign.justify, style: TextStyle(fontSize: 16)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 16, right: 16, top: 15),
              child: Text("Release Date", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Text(
                newFormatt.format(movie.results[index].releaseDate),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
