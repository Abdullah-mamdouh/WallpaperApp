
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';

class ImageDetail extends StatefulWidget {
  ImageDetail({Key? key,
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
    _requestPermission();
  }
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();

    final info = statuses[Permission.storage];

    //if user permanently denied permission, open app setting..
    if (info == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.photo.src!.large2x!,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                  imageUrl: widget.photo.src!.large2x!,
                  placeholder: (context, url) => Container(
                    color: Color(0xfff5f8fd),
                  ),
                  fit: BoxFit.cover),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 5, top:60),
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
                borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _save(widget.photo.src.large2x);
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Photo is downloaded.')));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.download_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                _save(widget.photo.src.large2x);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Photo is downloaded.')));
                              }),
                          Text(
                            "Download",
                            style: Theme.of(context).textTheme.caption!.apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ProviderHelper>(
                          builder: (context, pp, child) =>IconButton(
                              icon: isfavourite ? Icon(Icons.favorite,color: Colors.red,size: 40,)
                                  : Icon(Icons.favorite_border_outlined,color: Colors.white,size: 40,),
                              onPressed: () {
                                fav.add(widget.photo.src.large2x);
                                Provider.of<ProviderHelper>(
                                    context,
                                    listen: false).favorite(!isfavourite);
                                isfavourite = pp.isFavorite;

                                /// add this image to favourite photos
                                Provider.of<ProviderHelper>(context,
                                    listen: false).addFavouritePhoto(widget.photo);
                              }),),
                        Text(
                          "Favorite",
                          style: Theme.of(context).textTheme.caption!.apply(color: Colors.white),
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
  _save(String url) async {
    var status = await Permission.storage.status.isGranted;
    if (status) {
      var response = await Dio().get(url,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "photo");
      //print(result);
    }
  }

/*
  addPhotoToFavorite(String photo) async{
    WidgetsBinding w = await WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? favorite_img = pref.getStringList('favo_Photos');
      favorite_img!.add(photo);
      print(favorite_img[0].toString());
      pref.setStringList('favo_Photos', favorite_img);

  }
  */
}
