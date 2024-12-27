import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_models.dart';
import 'package:news_app/repositoory/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineApi(
      String channelName) async {
    final CategoriesNewsModel response =
        await _rep.fetchNewsChannelHeadlineApi(channelName);
    final Map<String, dynamic> responseJson = response.toJson();
    return NewsChannelsHeadlinesModel.fromJson(responseJson);
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    final Map<String, dynamic> responseJson = response.toJson();
    return CategoriesNewsModel.fromJson(responseJson);
  }
}
