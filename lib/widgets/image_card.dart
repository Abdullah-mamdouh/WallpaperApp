import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/pages/image_detail.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';
import 'package:wallpaper/constant_utils/constants.dart';

class ImageCard extends StatelessWidget {
   ImageCard({Key key,this.photo, this.imageUrl, this.photographer, this.color, this.imageDetail, this.photographerUrl}) : super(key: key);

  final String imageUrl, photographer, color, imageDetail, photographerUrl;
  Photos photo;
   bool isfavourite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Theme.of(context).cardColor),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              print(imageDetail);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageDetail(
                        photo: photo,
                        photographer: photographer,
                            image: imageDetail,
                        photographerUrl: photographerUrl,
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.memoryNetwork(
                imageScale: 0.5,
                placeholder: kTransparentImage,
                image: imageUrl,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 15, top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
    Consumer<ProviderHelper>(
    builder: (context, pp, child) => IconButton(onPressed: (){
                        Provider.of<ProviderHelper>(
                          context,
                          listen: false)
                          .favorite(!isfavourite);
                      isfavourite = pp.isFavorite;
                      },
                          icon: isfavourite? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border_outlined,)),),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor(color),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
