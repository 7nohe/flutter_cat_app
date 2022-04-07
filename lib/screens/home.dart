import 'package:flutter/material.dart';
import 'package:flutter_cat_app/models/photo.dart';
import 'package:flutter_cat_app/view_models/search.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(builder: (context, searchModel, child) {
      return ListView.builder(
        itemCount: searchModel.photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => PhotoModal(
                        photo: searchModel.photos[index],
                      ),
                    ),
                  );
                },
                child: Hero(
                    tag: 'photo_' + searchModel.photos[index].id,
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Image.network(
                            searchModel.photos[index].urls['regular'])))),
          );
        },
      );
    });
  }
}

class PhotoModal extends StatelessWidget {
  final Photo photo;
  const PhotoModal({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: 'photo_' + photo.id,
            child: Image.network(
              photo.urls['regular'],
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
