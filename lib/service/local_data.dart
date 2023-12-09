import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/models/photos_model.dart';

import '../constant_utils/error/exceptions.dart';

const Favorite_Photos = 'favoritePhotos';

class LocalData {
  SharedPreferences? sharedPreferences;
  List<Photos>? favoritePhotos = [];

  addFavoritePhotos(Photos photoName) async {
    //sharedPreferences.setString(CACHED_POSTS, json.encode(postModelsToJson));
    //sharedPreferences.setStringList(Favorite_Photos, ['giza']);
    //List<Photos> locations = sharedPreferences.getStringList(Favorite_Photos);
    //locations != null? favoritePhotos = locations: [];
    //debugPrint(favoritePhotos!.toList().toString());

    sharedPreferences = await SharedPreferences.getInstance();

    favoritePhotos = await getFavoritePhotos();

    favoritePhotos!.add(photoName);
    List photosToJson = favoritePhotos!.map((photo) => photo.toJson()).toList();
    sharedPreferences!.setString(Favorite_Photos, json.encode(photosToJson));
    //print(photoName);
  }

  getFavoritePhotos() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences!.getString(Favorite_Photos);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      favoritePhotos = decodeJsonData
          .map<Photos>((jsonPhotos) => Photos.fromJson(jsonPhotos))
          .toList();
      return favoritePhotos;
    } else {
      return favoritePhotos;
    }
  }

  removePhoto(int index) async {
    sharedPreferences = await SharedPreferences.getInstance();
    favoritePhotos!.removeAt(index);
    List photosToJson = favoritePhotos!.map((photo) => photo.toJson()).toList();
    sharedPreferences!.setString(Favorite_Photos, json.encode(photosToJson));
  }
}
