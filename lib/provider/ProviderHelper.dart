import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/service/api.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/constant_utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/service/local_data.dart';

class ProviderHelper with ChangeNotifier {
  bool isFavorite = false;
  List<Photos> favoriteImages = [];
  List<Photos> myPhotos = [];
  List<Photos> get getFavoriteImages => favoriteImages;
  Random random = new Random();
  int? page, cat;
  LocalData localData = LocalData();

  setPage(int numb) {
    page = numb;
    addListener(() {
      notifyListeners();
    });
  }

  getData() async {
    page = random.nextInt(100);
    cat = random.nextInt(11);
    var response =
        await getRandomWallpaper(page! - 1, categoriesList[cat!], page!);
    response.photos!.forEach((element) {
      myPhotos.add(element);
      //print(element.toString());
    });
    notifyListeners();
    // addListener(() {
    //   notifyListeners();
    // });
  }

  addPhotoToFavorite(Photos photo) {
    favoriteImages.add(photo);
    print(favoriteImages[0].toString());
    notifyListeners();
  }

  addFavouritePhoto(Photos photo) async {
    await localData.addFavoritePhotos(photo);
  }

  getFavouritePhotos() async {
    favoriteImages = await localData.getFavoritePhotos();
    notifyListeners();
  }

  removeFavoritePhoto(int index) async {
    return await localData.removePhoto(index);
  }

  favorite(bool value) {
    isFavorite = value;
    //print(isFavorite.toString());
    notifyListeners();
  }

  requestPermission(BuildContext context) async {
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

  save(String url) async {
    var status = await Permission.storage.status.isGranted;
    if (status) {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "photo");
      //print(result);
    }
  }

  Future<void> setwallpaper(String imageUrl) async {
    int location = WallpaperManager.HOME_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    final bool result =
        (await WallpaperManager.setWallpaperFromFile(file.path, location));
  }
}
