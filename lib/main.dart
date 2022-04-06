import 'package:flutter/material.dart';
import 'package:flutter_cat_app/view_models/search.dart';
import 'package:flutter_cat_app/screens/favorite.dart';
import 'package:flutter_cat_app/screens/home.dart';
import 'package:flutter_cat_app/screens/notification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
          child: const MyHomePage(title: 'Flutter App Cat')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget currentScreen = const HomeScreen();
  final textEditingController = TextEditingController();

  Future<void> showSearchDialog(
      BuildContext context, Function(String text) search) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Search for a cat'),
            content: TextField(
              controller: textEditingController,
              decoration:
                  const InputDecoration(hintText: "Type something here"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Search'),
                onPressed: () {
                  search(textEditingController.text);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(builder: (context, searchModel, child) {
      return Scaffold(
        body: currentScreen,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearchDialog(context, (text) {
              searchModel.search(text: text);
              Navigator.of(context).pop();
            });
          },
          child: const Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomeScreen();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    setState(() {
                      currentScreen = const NotificationScreen();
                    });
                  },
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    setState(() {
                      currentScreen = const FavoriteScreen();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
