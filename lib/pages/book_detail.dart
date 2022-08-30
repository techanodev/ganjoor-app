import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/book/book_model.dart';
import 'package:ganjoor/models/poem/poem_model.dart';
import 'package:ganjoor/services/request.dart';
import 'package:ganjoor/widgets/loading.dart';
import 'package:ganjoor/widgets/poet_detail/poem.dart';

class BookDetail extends StatefulWidget {
  final BookModel book;
  const BookDetail({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  List<PoemModel> _poems = [];
  List<PoemModel> _p = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
    _searchController.addListener(() {
      setState(() {
        String q = _searchController.text;
        _p = _poems.where((element) => element.excerpt.contains(q)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text.isEmpty) {
      _p = _poems;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              widget.book.title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              alignment: Alignment.centerRight,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _poems.isNotEmpty
              ? SafeArea(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: CupertinoTextField(
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          placeholder: 'جستجوی شعر',
                          placeholderStyle: const TextStyle(
                            color: Color(0xffC4C6CC),
                            fontSize: 14.0,
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              _searchController.text = '';
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: _searchController.text.isEmpty
                                    ? const Color(0xffC4C6CC)
                                    : Colors.black,
                              ),
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
                            color: const Color(0xffF0F1F5),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          _p.length,
                          (index) => Poem(
                            poem: _p[index],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : loading()),
    );
  }

  _getData() {
    Request('/api/ganjoor/cat/${widget.book.id}').get((data) {
      if (data != null) {
        setState(() {
          _poems = data['cat']['poems']
              .map<PoemModel>((e) => PoemModel.fromJson(e))
              .toList();
        });
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            title: 'خطا',
            aligment: Alignment.center,
            desc:
                'هنگام برقراری ارتباط با سرور با خطا مواجه شدیم لطفا اینترنت خود را چک کرده و مجددا تلاش کنید',
            btnOkText: 'تلاش مجدد',
            btnOkColor: Colors.green,
            btnOkOnPress: _getData,
            onDissmissCallback: (e) {
              Navigator.of(context).pop();
            }).show();
      }
    });
  }
}
