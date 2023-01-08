import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/pages/search_view.dart';

import '../constant_utils/constants.dart';
import '../models/category_model.dart';
import '../widgets/slide_fade_animation.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> category = [];

  @override
  void initState() {
    category = categories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: category.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              bottom: false,
              child: GridView.builder(
                  padding: EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: category.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return SlideFadeAnimation(
                        index: index,
                        animationDuration: 1000,
                        verticalOffset: 200,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                          keyword: category[index].label,
                                        )));
                          },
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(
                                          category[index].imageUrl),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueGrey.withOpacity(0.5)),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      category[index].label,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 45,
                                        fontFamily: 'DancingScript',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ));
                  }),
            ),
    );
  }
}
