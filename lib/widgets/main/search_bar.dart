import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PoetSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  const PoetSearchBar({Key? key, required this.searchController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
      child: Container(
        height: 36.0,
        width: double.infinity,
        child: CupertinoTextField(
          controller: searchController,
          keyboardType: TextInputType.text,
          placeholder: 'جستجوی برای شاعر',
          placeholderStyle: const TextStyle(
            color: Color(0xffC4C6CC),
            fontSize: 14.0,
          ),
          suffix: GestureDetector(
            onTap: () {
              searchController.text = '';
            },
            child: Icon(
              Icons.cancel_outlined,
              color: searchController.text.isEmpty
                  ? Color(0xffC4C6CC)
                  : Colors.black,
            ),
          ),
          prefix: const Padding(
            padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
            child: Icon(
              Icons.search,
              color: Color(0xffC4C6CC),
            ),
          ),
          cursorColor: Colors.grey,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(0xffF0F1F5),
          ),
        ),
      ),
    );
  }
}
