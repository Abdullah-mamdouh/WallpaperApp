import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/pages/details_page/my_icon_button_widget.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';

class ImageDetail extends StatefulWidget {
  ImageDetail({
    Key? key,
    this.photo,
    //required this.image, required this.photographer, required this.photographerUrl
  }) : super(key: key);

  //final String image, photographer,photographerUrl;
  final photo;
  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  bool isfavourite = false;
  List fav = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProviderHelper>(context,listen: false).requestPermission(context);
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();

    final info = statuses[Permission.storage];

    //if user permanently denied permission, open app setting..
    if (info == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Text("Open app setting to grant access."),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = widget.photo.src;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: image!.large2x!,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                  imageUrl: image!.large2x!,
                  placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, top: 60),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Spacer(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xff1C1B1B).withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyIconButton(
                      icon: Icons.download_rounded,
                      iconName: 'Download',
                      action: () =>
                          Provider.of<ProviderHelper>(context,listen: false).save(image.large2x),),
                  MyIconButton(
                      icon: Icons.wallpaper,
                      iconName: 'set Wallpaper',
                      action: () => Provider.of<ProviderHelper>(context,listen: false)
                          .setwallpaper(image.large2x),),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ProviderHelper>(
                          builder: (context, pp, child) => IconButton(
                              icon: isfavourite
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 40,
                                    )
                                  : Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                              onPressed: () {
                                fav.add(image.large2x);
                                Provider.of<ProviderHelper>(context,
                                        listen: false)
                                    .favorite(!isfavourite);
                                isfavourite = pp.isFavorite;

                                /// add this image to favourite photos
                                Provider.of<ProviderHelper>(context,
                                        listen: false)
                                    .addFavouritePhoto(widget.photo);
                              }),
                        ),
                        Text(
                          "Favorite",
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
