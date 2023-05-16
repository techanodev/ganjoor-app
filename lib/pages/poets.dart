import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/services/request.dart';
import 'package:ganjoor/widgets/loading.dart';
import 'package:ganjoor/widgets/main/poet.dart';
import 'package:ganjoor/widgets/main/search_bar.dart';

class PoetsListPage extends StatefulWidget {
  const PoetsListPage({Key? key}) : super(key: key);

  @override
  State<PoetsListPage> createState() => _PoetsListPageState();
}

class _PoetsListPageState extends State<PoetsListPage> {
  List<PoetModel> _poets = [];
  List<PoetModel> _p = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    if (_poets.length == 0) _getData();
    _searchController.addListener(() {
      setState(() {
        String q = _searchController.text;
        _p = _poets.where((element) => element.name.contains(q)).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text.isEmpty) {
      _p = _poets;
    }
    return Scaffold(
      body: _poets.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  snap: true,
                  pinned: true,
                  floating: true,
                  title: const Text(
                    'شعرا',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        const SizedBox(height: 110),
                        PoetSearchBar(searchController: _searchController),
                      ],
                    ),
                  ),
                  expandedHeight: 150,
                  backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                  shadowColor: Colors.grey.withAlpha(40),
                ),
                _buildListPoets(),
              ],
            )
          : loading(),
    );
  }

  Widget _buildListPoets() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= _p.length) {
            return Container(
              height: 120,
            );
          }
          return PoetTile(
            poet: _p[index],
          );
        },
        childCount: _p.length + 1,
      ),
    );
  }

  _getData() {
    Request('/api/ganjoor/poets').get((data) {
      if (data != null) {
        setState(() {
          _poets = data.map<PoetModel>((e) => PoetModel.fromJson(e)).toList();
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
          btnOkOnPress: _getData,
          btnOkText: 'تلاش مجدد',
          btnOkColor: Colors.green,
          dismissOnTouchOutside: false,
        ).show();
      }
    });
  }
}
