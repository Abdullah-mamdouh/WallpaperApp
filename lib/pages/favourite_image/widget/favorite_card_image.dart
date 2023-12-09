import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../constant_utils/constants.dart';
import '../../../models/photos_model.dart';
import '../../../provider/ProviderHelper.dart';
import '../../details_page/image_detail.dart';

class FavoriteCardImage extends StatelessWidget {
  FavoriteCardImage({
    Key? key,
    required this.index,
    required this.photo,
  }) : super(key: key);
  int index;
  Photos photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).cardColor),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // print(imageDetail);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageDetail(
                            photo: photo,
                            // photographer: photo.photographer!,
                            // image: photo.src!.large2x!,
                            // photographerUrl: photo.photographerUrl!,
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.memoryNetwork(
                imageScale: 0.5,
                placeholder: kTransparentImage,
                image: photo.src!.medium!,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 5, left: 15, top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Provider.of<ProviderHelper>(context, listen: false)
                              .removeFavoritePhoto(index);
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          //color: Colors.red,
                        ),
                      ),
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
                  color: HexColor(
                    photo.avgColor!,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
