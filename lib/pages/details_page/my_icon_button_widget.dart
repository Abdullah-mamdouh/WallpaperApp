
import 'package:flutter/material.dart';

class MyIconButton extends StatefulWidget {
  MyIconButton({Key? key, required this.icon, required this.iconName, required this.action}) : super(key: key);
  IconData icon;
  String iconName;
  Function action;

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: GestureDetector(
        onTap: () {
          widget.action();
          //_save(widget.photo.src.large2x);
          // Scaffold.of(context)
          //     .showSnackBar(SnackBar(content: Text('Photo is downloaded.')));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  //Icons.download_rounded
                  widget.icon,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () async {
                  widget.action();
                  //_save(widget.photo.src.large2x);
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Photo is downloaded.')));
                }),
            Text(
              "${widget.iconName}",
              style: Theme.of(context).textTheme.caption!.apply(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
