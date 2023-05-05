import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/pages/poet_detail.dart';

class PoetTile extends StatelessWidget {
  final PoetModel poet;
  const PoetTile({
    Key? key,
    required this.poet,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withAlpha(120),
            width: 0.4,
          ),
        ),
      ),
      child: ListTile(
        title: Text(poet.name),
        subtitle: Text(poet.nickname),
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
                poet.imageUrl,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoetDetail(
                id: poet.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
