import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/pages/favourite_image/widget/favorite_card_image.dart';
import 'package:wallpaper/service/api.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';
import 'package:wallpaper/widgets/changeThemeButtonWidget.dart';
import 'package:wallpaper/widgets/empty_page.dart';
import 'package:wallpaper/widgets/image_card.dart';

import '../../widgets/slide_fade_animation.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Favorites> {
  List<Photos>? myPhotos;

  @override
  Widget build(BuildContext context) {
    Provider.of<ProviderHelper>(context, listen: false).getFavouritePhotos();
    final _size = MediaQuery.of(context).size;
    myPhotos = Provider.of<ProviderHelper>(context).getFavoriteImages;

    return Scaffold(
        body: Stack(
      children: [
        Scaffold(
            //extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 65,
              backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/3536991/pexels-photo-3536991.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                      //backgroundColor: Colors.transparent,
                    ),
                  ),
                  Text(
                    "Abdullah ",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
              actions: [
                Container(
                  child: ChangeThemeButtonWidget(),
                  margin: EdgeInsets.all(3),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ],
            ),
            body: myPhotos!.isEmpty
                ? EmptyPage()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: StaggeredGridView.countBuilder(
                      primary: false,
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      itemCount: myPhotos!.length,
                      itemBuilder: (context, index) {
                        var photo = myPhotos![index];
                        return SlideFadeAnimation(
                            index: index,
                            animationDuration: 2000,
                            verticalOffset: 200,
                            child:
                                FavoriteCardImage(index: index, photo: photo));
                        /*ImageCard(
                photo: photo,
                imageDetail: photo.src!.large2x!,
                imageUrl: photo.src!.medium!,
                photographer: photo.photographer!,
                color: photo.avgColor!,
                photographerUrl: photo.photographerUrl!
            );*/
                      },
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    ),
                  )),
      ],
    ));
  }
}
