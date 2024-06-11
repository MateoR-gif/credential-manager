import 'dart:convert';
import 'package:app/models/NewsModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'https://newsapi.org/v2/everything?q=cybersecurity&from=2024-05-11&sortBy=publishedAt&apiKey=c4f98410b6004daf8519b9136316b156';
  int page = 1;

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        print('Fetch completo');
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      print(error);
      return throw error;
    }
  }
}
