import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cat_app/models/photo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List> getPhotos() async {
  // Get Client Id from .env
  String clientId = dotenv.get('UNSPLASH_CLIENT_ID');
  // Get photos from unsplash
  Response response = await Dio().get(
      'https://api.unsplash.com/search/photos/?query=cat&client_id=' +
          clientId);
  return response.data['results'] as List;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Photo> photos = (snapshot.data! as List)
              .map((json) => Photo.fromJson(json))
              .toList();
          return ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Image.network(photos[index].urls['regular'])
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
      future: getPhotos(),
    );
  }
}
