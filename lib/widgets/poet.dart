import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PoetTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const PoetTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imageUrl})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Container(
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey.shade200,
          backgroundBlendMode: BlendMode.saturation,
        ),
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.none,
            image: NetworkImage(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
