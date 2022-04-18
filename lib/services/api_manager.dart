import 'package:http/http.dart' as http;
import '../models/newsinfo.dart';
import 'dart:convert';

class ApiManager {
  Future<PostsModel> getMovies() async {
    final result = await http.Client().get(Uri.parse('https://api.themoviedb.org/3/movie/upcoming?api_key=4ace3c380c51fa8a8483e1e93cdc0160'));
    if (result.statusCode != 200) throw Exception();
    final jsonDecoded = json.decode(result.body);
    //print(result.body);
    return PostsModel.fromJson(jsonDecoded);
  }
}
