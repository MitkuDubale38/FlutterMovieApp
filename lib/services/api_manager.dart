import 'package:http/http.dart' as http;
import '../models/newsinfo.dart';
import 'dart:convert';

class ApiManager {
  Future<PostsModel> getMovies(int page) async {
    final result = await http.Client().get(Uri.parse('https://api.themoviedb.org/3/movie/upcoming?api_key=4ace3c380c51fa8a8483e1e93cdc0160&page=$page'));
    if (result.statusCode != 200) throw Exception();
    final jsonDecoded = json.decode(result.body);
    //print(result.body);
    return PostsModel.fromJson(jsonDecoded);
  }

  Future<List> findMovies(String title) async {
    http.Response result = await http.get("https://api.themoviedb.org/3/search/movie?api_key=4ace3c380c51fa8a8483e1e93cdc0160&query=$title");
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
