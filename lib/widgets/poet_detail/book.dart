import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/book/book_model.dart';
import 'package:ganjoor/models/poet/poet_complete.dart';

class Book extends StatelessWidget {
  final BookModel book;
  final Color color;
  const Book({Key? key, required this.book, required this.color})
      : super(key: key);
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
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            book.title[0],
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          book.title,
        ),
      ),
    );
  }
}
