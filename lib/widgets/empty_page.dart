
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/empty_store.json",));
  }
}
