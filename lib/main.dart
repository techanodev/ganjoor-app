import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/services/ganjoor_service.dart';
import 'package:ganjoor/services/request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PoetModel> _poets = [];
  @override
  initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     'شعرا',
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 30,
        //       fontWeight: FontWeight.w900,
        //     ),
        //   ),
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.sort,
        //         color: Colors.black,
        //       ),
        //     )
        //   ],
        //   backgroundColor: Colors.white,
        //   bottom: PreferredSize(
        //       preferredSize: const Size.fromHeight(80.0), child: _searchBar()),
        // ),
        body: _poets.length < 0
            ? _buildLoading()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
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
                          SizedBox(height: 110),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 6.0, 16.0, 16.0),
                            child: Container(
                              height: 36.0,
                              width: double.infinity,
                              child: CupertinoTextField(
                                keyboardType: TextInputType.text,
                                placeholder: 'جستجوی برای شاعر',
                                placeholderStyle: TextStyle(
                                  color: Color(0xffC4C6CC),
                                  fontSize: 14.0,
                                ),
                                prefix: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      9.0, 6.0, 9.0, 6.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Color(0xffC4C6CC),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Color(0xffF0F1F5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: 150,
                    backgroundColor: Color.fromARGB(255, 250, 250, 250),
                    leading: IconButton(
                      icon: Icon(
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
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(100),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.all(15),
      child: const TextField(
        cursorColor: Colors.black12,
        decoration: InputDecoration(
          hintText: 'جستجوی برای شعر و شاعر',
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: 16,
          ),
        ),
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
          child: ListTile(
            title: Text(_poets[index].name),
            subtitle: Text(_poets[index].nickname),
            leading: Container(
              foregroundDecoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                backgroundBlendMode: BlendMode.saturation,
              ),
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    GanjoorService.baseUrl + _poets[index].imageUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
        childCount: _poets.length,
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
        _getData();
      }
    });
  }
}
