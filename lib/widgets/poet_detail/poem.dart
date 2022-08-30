import 'package:flutter/material.dart';
import 'package:ganjoor/models/poem/poem_model.dart';

class Poem extends StatelessWidget {
  final PoemModel poem;

  const Poem({Key? key, required this.poem}) : super(key: key);
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
        contentPadding: EdgeInsets.zero,
        title: Text(
          poem.title,
        ),
        subtitle: Text(
          poem.excerpt,
        ),
      ),
    );
  }
}
