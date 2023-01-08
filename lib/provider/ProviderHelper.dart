

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallpaper/service/api.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/constant_utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/service/local_data.dart';

class ProviderHelper with ChangeNotifier{
  bool isFavorite = false;
  List<Photos> favoriteImages = [];
  List<Photos> myPhotos = [];
  List<Photos> get getFavoriteImages => favoriteImages;
  Random random = new Random();
  int? page ,cat;
  LocalData localData = LocalData();

  setPage(int numb){
    page= numb;
    addListener(() {
      notifyListeners();
    });
  }

  getData() async{
    page = random.nextInt(100);
    cat = random.nextInt(11);
    var response = await getRandomWallpaper(page!-1, categoriesList[cat!], page!);
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

  addFavouritePhoto(Photos photo) async{
    await localData.addFavoritePhotos(photo);
  }

  getFavouritePhotos() async{
    favoriteImages = await localData.getFavoritePhotos();
    notifyListeners();
  }

  removeFavoritePhoto(int index) async{
    return await localData.removePhoto(index);
  }

  favorite(bool value){
    isFavorite =value;
    //print(isFavorite.toString());
    notifyListeners();
  }

}