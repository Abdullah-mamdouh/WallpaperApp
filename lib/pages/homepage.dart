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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  Random random = new Random();
  int page ;
  //List<bool> isfavourite;

  bool closeSearch = true;
  String category = "nature";
  TextEditingController searchController = new TextEditingController();
  List<Photos> myPhotos = new List();
  @override
  void initState() {
    Provider.of<ProviderHelper>(context,listen: false).getData();
    page =random.nextInt(100);
    _scrollController = new ScrollController(initialScrollOffset: 5.0)..addListener(_scrollListener);
    Provider.of<ProviderHelper>(context,listen: false).getData();
    Provider.of<ProviderHelper>(context,listen: false).favorite_img;
    myPhotos = Provider.of<ProviderHelper>(context,listen: false).myPhotos;
    fetchPhotos();
    super.initState();
  }

  fetchPhotos() async {
    var response = await getRandomWallpaper(page-1, category, page);
    response.photos.forEach((element) {
       myPhotos.add(element);
    });
    setState(() {});
  }

  _scrollListener() {
    setState(() {
      closeSearch = true;
    });
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;

      Provider.of<ProviderHelper>(context,listen: false).setPage(page++);
      fetchPhotos();
      Provider.of<ProviderHelper>(context,listen: false).getData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // fetchPhotos();
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  text: 'Pexelify',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),overflow: TextOverflow.ellipsis,
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
                          Fluttertoast.showToast(msg: "Search field cannot be empty");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        keyword: searchController.text,
                                      )));
                        }
                      },
                      controller: searchController,
                      decoration: InputDecoration(hintText: "search wallpapers", border: InputBorder.none),
                    )),
                  ],
                ),
              ),
              crossFadeState: closeSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          primary: false,
          crossAxisCount: 2 ,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          itemCount: myPhotos.length,
          itemBuilder: (context, index) => ImageCard(photo: myPhotos[index],
            imageDetail: myPhotos[index].src.large2x,
            imageUrl: myPhotos[index].src.medium,
            photographer: myPhotos[index].photographer,
            color: myPhotos[index].avgColor,
            photographerUrl: myPhotos[index].photographerUrl
          ),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        ),
      ),
    );
  }
}
