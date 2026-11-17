import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_model.dart';

enum LoadState { idle, loading, success, error }

class NewsProvider extends ChangeNotifier {
  List<Article> _all = [];
  List<Article> _filtered = [];
  final Set<int> _favorites = {};
  LoadState _state = LoadState.idle;
  String _errorMsg = '';
  String _query = '';

  // ── Getters ──
  List<Article> get articles => _filtered;
  LoadState get state => _state;
  String get errorMsg => _errorMsg;
  int get favoriteCount => _favorites.length;
  bool isFavorite(int id) => _favorites.contains(id);

  // ── Fetch from API ──
  Future<void> fetchArticles() async {
    _state = LoadState.loading;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _all = data.map((e) => Article.fromJson(e)).toList();
        _applySearch();
        _state = LoadState.success;
      } else {
        _errorMsg = 'Server error: ${response.statusCode}';
        _state = LoadState.error;
      }
    } catch (e) {
      _errorMsg = 'Network error: ${e.toString()}';
      _state = LoadState.error;
    }

    notifyListeners();
  }

  // ── Search ──
  void search(String query) {
    _query = query.trim().toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    _filtered = _query.isEmpty
        ? List.from(_all)
        : _all
        .where((a) => a.title.toLowerCase().contains(_query))
        .toList();
  }

  // ── Favorites ──
  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}