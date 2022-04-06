import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cat_app/models/photo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List> searchPhotos({String text = ''}) async {
  // Get Client Id from .env
  String clientId = dotenv.get('UNSPLASH_CLIENT_ID');
  String url = Uri.encodeFull(
      'https://api.unsplash.com/search/photos/?query=cat+$text&client_id=$clientId');
  // Get photos from unsplash
  Response response = await Dio().get(url);
  return response.data['results'] as List;
}

class SearchViewModel extends ChangeNotifier {
  List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  SearchViewModel() {
    init();
  }

  Future<void> init() async {
    final data = await searchPhotos();
    _photos = data.map((json) => Photo.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> search({required String text}) async {
    final data = await searchPhotos(text: text);
    _photos = data.map((json) => Photo.fromJson(json)).toList();
    notifyListeners();
  }
}
