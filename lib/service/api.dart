import 'dart:convert';

import 'package:wallpaper/models/photos_model.dart';
//import 'package:wallpaper/utils/constants_ignore.dart';
import 'package:http/http.dart' as http;

Future<PhotosModel> getRandomWallpaper(
    int per_page, String keywords, int page_no) async {
  Map<String, String> params = {
    'per_page': per_page.toString(),
    'query': keywords,
    'page': page_no.toString()
  };

  final apiKEY =
      '563492ad6f917000010000015fe4eddae782456a8d1783a3951766de'; //Follow the documentation to collect the api Key from https://www.pexels.com/api/

//'api.pexels.com/v1/search
  final response = await http.get(
      Uri.https('api.pexels.com', 'v1/search', params),
      headers: {"Authorization": '$apiKEY'});

  if (response.statusCode == 200) {
    return PhotosModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data.');
  }
}
