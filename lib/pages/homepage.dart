import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/service/api.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/pages/search_view.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';
import 'package:wallpaper/widgets/image_card.dart';
import 'package:wallpaper/widgets/images_view_widget.dart';

import '../constant_utils/constants.dart';
import '../widgets/empty_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController? _scrollController;
  Random random = new Random();
  int? page;
  //List<bool> isfavourite;

  bool closeSearch = true;
  String category = "nature";
  TextEditingController searchController = new TextEditingController();
  List<Photos> myPhotos = [];

  @override
  void initState() {
    final helper = Provider.of<ProviderHelper>(context, listen: false);
    helper.getData();
    page = random.nextInt(100);
    _scrollController = new ScrollController(initialScrollOffset: 10.0)
      ..addListener(_scrollListener);
    //Provider.of<ProviderHelper>(context, listen: false).getData();
    //Provider.of<ProviderHelper>(context, listen: false).favorite_img;

    //fetchPhotos();
    super.initState();
  }

  fetchPhotos() async {
    //print('${page!-1} , $category , ${page!-1}');
    category = categoriesList[Random().nextInt(11)];
    var response = await getRandomWallpaper(page! - 1, category, page!);
    response.photos!.forEach((element) {
      myPhotos.add(element);
    });
    setState(() {});
  }

  _scrollListener() {
    // setState(() {
    //   closeSearch = true;
    // });
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      page = page! + 1;
      // Provider.of<ProviderHelper>(context, listen: false).setPage(page! + 1);
      fetchPhotos();
      //Provider.of<ProviderHelper>(context, listen: false).getData();
    }
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //fetchPhotos();
    //Provider.of<ProviderHelper>(context, listen: false).getData();
    myPhotos = Provider.of<ProviderHelper>(context).myPhotos;
    //debugPrint(page.toString());
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 65,
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: 'Fantastic Wallpaper',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          actions: [
            AnimatedCrossFade(
                firstChild: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      padding: EdgeInsets.only(right: 30),
                      icon: Icon(Icons.search, size: 30),
                      onPressed: () {
                        setState(() {
                          closeSearch = false;
                        });
                      }),
                ),
                secondChild: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (String value) {
                          if (value.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Search field cannot be empty");
                          } else {
                            closeSearch = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                          keyword: searchController.text,
                                        )));
                          }
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: "search wallpapers",
                            border: InputBorder.none),
                      )),
                    ],
                  ),
                ),
                crossFadeState: closeSearch
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 400))
          ],
        ),
        body: //myPhotos.isNotEmpty ?
            myPhotos.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ImagesViewWidget(
                    myPhotos: myPhotos,
                    scrollController: _scrollController,
                  ),

        );
  }
}
