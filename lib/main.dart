import 'package:bloctutorial/cubit/countercubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/countercubit.dart';
import 'models/newsinfo.dart';
import 'services/api_manager.dart';
import 'movie_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      debugShowCheckedModeBanner: false,
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text(
      'Index 1: Business',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Movies"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        iconSize: 40,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostsModel? posts;
  bool isLoaded = false;
  int page = 1;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Set favoriteMovieList = Set();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    posts = await ApiManager().getMovies(page);
    if (posts != null) {
      setState(() {
        isLoaded = true;
        page = page;
      });
    }
    print(posts?.page = 2);
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      body: Visibility(
        visible: isLoaded,
        child: SingleChildScrollView(
          child: Column(
            children: [
              RefreshIndicator(
                color: Colors.blue,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  getData();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: posts?.results.length,
                  itemBuilder: (BuildContext context, int position) {
                    //adding movie to favorite
                    bool isFavorite = favoriteMovieList.contains(posts!.results[position]);

                    // seting image or default image
                    if (posts!.results[position].posterPath != null) {
                      image = NetworkImage(iconBase + posts!.results[position].posterPath);
                    } else {
                      image = NetworkImage(defaultImage);
                    }
                    final postions = posts!.results;
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.blue, content: Text('${posts!.results[position].title} Dismissed')));
                        setState(() {
                          postions.removeAt(position);
                        });
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (_) => MovieDetail(
                                      movie: posts as PostsModel,
                                      index: position,
                                    ));
                            Navigator.push(context, route);
                          },
                          leading: Hero(
                            tag: posts!.results[position].title,
                            child: CircleAvatar(
                              backgroundImage: image,
                            ),
                          ),
                          trailing: IconButton(
                            icon: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border, color: Colors.blue),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                //add to favorite or remove to favorite
                                if (isFavorite) {
                                  favoriteMovieList.remove(posts!.results[position]);
                                } else {
                                  favoriteMovieList.add(posts!.results[position]);
                                }
                              });
                            },
                          ),
                          title: Text(posts!.results[position].title),
                          subtitle: Text('Released: ' + posts!.results[position].title + ' - ' + posts!.results[position].voteAverage.toString() + ' ⭐'),
                        ),
                      ),
                      background: Container(
                        color: Colors.red[400],
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (page != posts?.totalPages) {
                        page = page + 1;
                        getData();
                      } else {
                        page = 1;
                      }
                    });
                  },
                  child: Text(page == posts?.totalPages ? 'End of upcoming movies' : 'More Movies'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
