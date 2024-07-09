import 'package:flutter/material.dart';

import 'image_container.dart';

class UserPic extends StatelessWidget {
  const UserPic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const SizedBox(
        height: 40,
        width: 40,
        child: ImageContainer(
          networkImg:
              'https://scontent.faly8-1.fna.fbcdn.net/v/t1.6435-9/131937156_1089661931468344_124679938646192511_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=7b2446&_nc_ohc=xloR2OYCqokQ7kNvgGb0P0X&_nc_ht=scontent.faly8-1.fna&oh=00_AYDPA7jqxvVbrGuQptN2LJ_4wauPTDHdTRSW-Ni7E_OxQA&oe=66B541F3',
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 15,
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green,
          ),
        ),
      ),
    ]);
  }
}
