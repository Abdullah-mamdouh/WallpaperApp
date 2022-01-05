

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallpaper/service/api.dart';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/constant_utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHelper with ChangeNotifier{
  bool isFavorite = false;
  List favorite_img = new List();
  List<Photos> myPhotos = new List();
  Random random = new Random();
  int page ,cat;
  setPage(int numb){
    page= numb;
    addListener(() {
      notifyListeners();
    });
  }
  getData() async{
    page = random.nextInt(100);
    cat = random.nextInt(11);
    var response = await getRandomWallpaper(page-1, category[cat], page);
    response.photos.forEach((element) {
      myPhotos.add(element);
      //print(element.toString());
    });
    notifyListeners();
    // addListener(() {
    //   notifyListeners();
    // });

  }
  addPhotoToFavorite(Photos photo) {
    favorite_img.add(photo);
    addListener(() {
      print(favorite_img[0].toString());
      notifyListeners();
    });
  }
  favorite(bool value){
    isFavorite =value;
    //print(isFavorite.toString());
    notifyListeners();
  }
}