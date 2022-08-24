import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/services/request.dart';
import 'package:ganjoor/widgets/poet.dart';
import 'package:ganjoor/widgets/search_bar.dart';

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
    super.initState();
    _getData();
    _searchController.addListener(() {
      setState(() {
        String q = _searchController.text;
        _p = _poets.where((element) => element.name.contains(q)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text.isEmpty) {
      _p = _poets;
    }
    return Scaffold(
      body: _poets.isEmpty
          ? _buildLoading()
          : CustomScrollView(
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
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    tooltip: 'Menu',
                    onPressed: () {},
                  ),
                ),
                _buildListView(),
              ],
            ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.grey,
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withAlpha(120),
                width: 0.4,
              ),
            ),
          ),
          child: PoetTile(
            title: _p[index].name,
            subtitle: _p[index].nickname,
            imageUrl: _p[index].imageUrl,
          ),
        ),
        childCount: _p.length,
      ),
    );
  }

  _getData() {
    Request('/api/ganjoor/poets').get((data) {
      if (data != null) {
        List<PoetModel> poets = [];
        data.forEach((item) {
          poets.add(PoetModel.fromJson(item));
        });
        setState(() {
          _poets = poets;
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
        ).show();
      }
    });
  }
}
