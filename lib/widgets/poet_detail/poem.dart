import 'package:flutter/material.dart';
import 'package:sheidaie/models/poem/poem_model.dart';
import 'package:sheidaie/pages/poem_detail.dart';

class Poem extends StatelessWidget {
  final PoemModel poem;

  const Poem({Key? key, required this.poem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoemDetail(
            id: poem.id,
          ),
        ),
      ),
      child: Container(
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
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
