import 'package:flutter/material.dart';

import '../constants.dart';

class ImageContainer extends StatelessWidget {
  final String networkImg;

  const ImageContainer({super.key, required this.networkImg});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width:50 ,
      decoration: BoxDecoration(
          color: kFourthColor,
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(networkImg),
          ),
        ));
  }
}
