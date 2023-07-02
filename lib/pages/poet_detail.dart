import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheidaie/models/poem/poem_model.dart';
import 'package:sheidaie/models/poet/poet_complete.dart';
import 'package:sheidaie/services/request.dart';
import 'package:sheidaie/widgets/loading.dart';
import 'package:sheidaie/widgets/poet_detail/app_bar.dart';
import 'package:sheidaie/widgets/poet_detail/book.dart';
import 'package:sheidaie/widgets/poet_detail/poem.dart';

class PoetDetail extends StatefulWidget {
  final int id;
  const PoetDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<PoetDetail> createState() => _PoetDetailState();
}

class _PoetDetailState extends State<PoetDetail> {
  PoetCompleteModel? _poet;
  bool _poemIsLoading = false;
  List<PoemModel> _poems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _getData();
    _searchController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _poet != null
            ? SafeArea(
                child: ListView(
                  children: [
                    PoetDetailAppBar(poet: _poet!),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: CupertinoTextField(
                        onSubmitted: _searchSubmitted,
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
                            _poems = [];
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: _poemIsLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: loading(),
                                  )
                                : Icon(
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
                    _poemsWidget(),
                    Container(
                      margin: EdgeInsets.only(bottom: 120),
                      child: _bookWidget(),
                    ),
                  ],
                ),
              )
            : loading(),
      ),
    );
  }

  _getData() {
    Request('/api/ganjoor/poet/${widget.id}').get((data) {
      if (data != null) {
        setState(() {
          _poet = PoetCompleteModel.fromJson(data);
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
              if (e == DismissType.MODAL_BARRIER) {
                Navigator.of(context).pop();
              }
            }).show();
      }
    });
  }

  _searchSubmitted(String q) {
    if (q.isEmpty) {
      return;
    }

    setState(() {
      _poemIsLoading = true;
    });

    q = q.replaceAll(' ', '+');
    String url = '/api/ganjoor/poems/search?term=$q&poetId=${_poet!.id}';

    Request(url).get((data) {
      setState(() {
        _poemIsLoading = false;
      });
      if (data != null) {
        if (data.isEmpty) {
          SnackBar snackBar = const SnackBar(
              content: Text('شعری با مشخصات مورد نظر شما یافت نشد.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        _poems = data.map<PoemModel>((e) => PoemModel.fromJson(e)).toList();
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
          btnOkOnPress: () {
            _searchSubmitted(q);
          },
          onDissmissCallback: (d) {
            setState(() {
              _poemIsLoading = false;
              _searchController.clear();
              _poems = [];
            });
          },
          btnOkText: 'تلاش مجدد',
          btnOkColor: Colors.green,
        ).show();
      }
    });
  }

  Widget _poemsWidget() {
    return _poems.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'شعر ها',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${_poems.length} شعر',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  _poems.length,
                  (index) => Poem(poem: _poems[index]),
                ),
              )
            ],
          )
        : Container();
  }

  Widget _bookWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: const Text(
            'کتاب ها',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Column(
          children: List.generate(
            _poet!.books.length,
            (index) => Book(
              book: _poet!.books[index],
              color: index % 2 == 0 ? Colors.blue : Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
