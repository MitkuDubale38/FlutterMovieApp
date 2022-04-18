import 'dart:html';

import 'package:bloctutorial/cubit/countercubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/countercubit.dart';
import 'models/newsinfo.dart';
import 'services/api_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PostsModel? posts;
  bool isLoaded = false;
  int? page;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    posts = await ApiManager().getMovies();
    if (posts != null) {
      setState(() {
        isLoaded = true;
        page = page;
      });
    }
    print(posts?.results[0].title);
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return MaterialApp(
      // Application name
      debugShowCheckedModeBanner: false,
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Upcoming Movies"),
        ),
        body: Visibility(
          visible: isLoaded,
          child: Column(
            children: [
              ListView.builder(
                  itemCount: posts?.results.length,
                  itemBuilder: (BuildContext context, int position) {
                    if (posts!.results[position].posterPath != null) {
                      image = NetworkImage(iconBase + posts!.results[position].posterPath);
                    } else {
                      image = NetworkImage(defaultImage);
                    }
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: image,
                        ),
                        title: Text(posts!.results[position].title),
                        subtitle: Text('Released: ' + posts!.results[position].title + ' - Vote: ' + posts!.results[position].voteAverage.toString()),
                      ),
                    );
                  }),
              ElevatedButton(
                onPressed: () {},
                child: Text('Next Page'),
              )
            ],
          ),
          replacement: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
