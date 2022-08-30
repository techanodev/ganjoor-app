import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet_complete.dart';

class PoetDetailAppBar extends StatelessWidget {
  final PoetCompleteModel poet;
  const PoetDetailAppBar({Key? key, required this.poet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          poet.imageUrl,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poet.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(poet.nickname),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'زاده : ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                            '${poet.birthYear} هجری شمسی در ${poet.birthPlace}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'درگذشت : ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                            '${poet.deathYear} هجری شمسی در ${poet.deathPlace}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ClipRect(
          clipper: PoetAppBarPad(),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpandText(
                poet.description,
                textAlign: TextAlign.justify,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PoetAppBarPad extends CustomClipper<Rect> {
  final EdgeInsets padding = const EdgeInsets.only(bottom: 30);

  @override
  Rect getClip(Size size) => padding.inflateRect(Offset.zero & size);

  @override
  bool shouldReclip(PoetAppBarPad oldClipper) => oldClipper.padding != padding;
}
