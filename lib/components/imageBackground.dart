import 'package:flutter/material.dart';

class ImageBackground extends StatelessWidget {
  final String assetImage;

  ImageBackground({this.assetImage});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(assetImage), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
