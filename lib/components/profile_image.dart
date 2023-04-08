import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
    this.imageProvider,
    int i, {
    super.key,
    this.radius = 20,
  });

  final double radius;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    // wrapped around a column so that the avatar doesn't stretch
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        )
      ],
    );
  }
}
