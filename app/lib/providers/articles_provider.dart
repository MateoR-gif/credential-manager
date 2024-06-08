import 'dart:convert';
import 'package:app/models/NewsModel.dart';
import 'package:app/services/NewsApiService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticlesProvider extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService(); // Crea una instancia de ApiService

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> fetchArticles({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (refresh) {
      _articles = [];
    }

    try {
      List<Article> fetchedArticles = await _apiService.fetchArticles(); // Usa ApiService
      _articles.addAll(fetchedArticles);
    } catch (e) {
      // Manejo de errores
      print('Error fetching articles: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}