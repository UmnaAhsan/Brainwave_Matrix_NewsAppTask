import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_models.dart';

import '../models/news_channel_headlines_models.dart';

class NewsRepository {
  Future<CategoriesNewsModel> fetchNewsChannelHeadlineApi(
      String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=fe6e0a52b5254752be349733c5763dc4';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('response.body');
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('ERROR');
  }

  Future<NewsChannelsHeadlinesModel> fetchCategoriesNewsApi(
      String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=fe6e0a52b5254752be349733c5763dc4';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('response.body');
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('ERROR');
  }

  Future<CategoriesNewsModel> fetachCategoriesNewsApiHealth(
      String health) async {
    String url =
        'https://newsapi.org/v2/everything?q=health&apiKey=fe6e0a52b5254752be349733c5763dc4';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('response.body');
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('ERROR');
  }
}
