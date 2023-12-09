import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/widgets/slide_fade_animation.dart';

import '../models/photos_model.dart';
import 'image_card.dart';

class ImagesViewWidget extends StatelessWidget {
  ImagesViewWidget(
      {Key? key, required this.myPhotos, required this.scrollController})
      : super(key: key);
  ScrollController? scrollController;
  List<Photos> myPhotos;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: false,
        //physics: const NeverScrollableScrollPhysics(),
        controller: scrollController,
        primary: false,
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: myPhotos.length,
        itemBuilder: (context, index) {
          var photo = myPhotos[index];
          if (index != myPhotos.length - 1) {
            return SlideFadeAnimation(
              index: index,
              animationDuration: 2000,
              verticalOffset: 200,
              child: ImageCard(
                photo: photo,
                // imageDetail: photo.src!.large2x!,
                // imageUrl: photo.src!.medium!,
                // photographer: photo.photographer!,
                // color: photo.avgColor!,
                // photographerUrl: photo.photographerUrl!
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      ),
    );
  }
}
