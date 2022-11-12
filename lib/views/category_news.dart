import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utills/NewsTile.dart';
import 'package:news_app/views/home.dart';
import 'package:news_app/views/pagenotfound.dart';
import 'package:news_app/views/search_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/utills/theme.dart';

class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({super.key, required this.category});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsclass = CategoryNewsClass();
    await newsclass.getNews(widget.category);
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }
  FutureOr onGoBack(dynamic value) {
    // refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: is_dark
          ? ThemeData(
              brightness: Brightness.dark,
            )
          : ThemeData(
              brightness: Brightness.light,
            ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: is_dark ? Colors.black12 : Colors.white,
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
            },
            color: is_dark ? Colors.white : Colors.black,
          ),
          title: Text(
            "Ignite News",
            style: TextStyle(
              color:
                  is_dark ? Colors.white : Color.fromARGB(255, 102, 109, 255),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    )).then(onGoBack);
              },
              icon: Icon(Icons.search,
                  color: is_dark ? Colors.white : Colors.black),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (is_dark == false)
                    setdark(true);
                  else
                    setdark(false);
                });
              },
              icon: Icon(
                is_dark ? Icons.dark_mode : Icons.light_mode,
                color: is_dark ? Colors.white : Colors.black,
              ),
            ),
          ],
          // centerTitle: true,
          elevation: 0.0,
        ),
        body: _loading
            ? SpinKitSpinningLines(
                size: 100.0,
                color: is_dark ? Colors.white : Colors.black,
              )
            : SingleChildScrollView(
                child: articles.isEmpty
                    ? PageNotFound()
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(top: 16, left: 10, right: 10),
                              child: ListView.builder(
                                itemCount: articles.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return NewsTile(
                                    imageUrl: articles[index].urlToImage,
                                    // after .attribute of api
                                    title: articles[index].title,
                                    desc: articles[index].description,
                                    url: articles[index].url,
                                    is_dark: is_dark,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
