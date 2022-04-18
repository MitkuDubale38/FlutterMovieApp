import 'package:bloctutorial/cubit/countercubit.dart';
import 'package:flutter/material.dart';
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
      });
    }
    print(posts?.results[0].title);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter API"),
        ),
        body: Visibility(
          visible: isLoaded,
          child: ListView.builder(
              itemCount: posts?.results.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(posts!.results[position].title),
                    subtitle: Text('Released: ' + posts!.results[position].title + ' - Vote: ' + posts!.results[position].voteAverage.toString()),
                  ),
                );
              }),
          replacement: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
