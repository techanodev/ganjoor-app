import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/services/ganjoor_service.dart';
import 'package:ganjoor/services/request.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PoetModel> _poets = [];
  initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _poets.isNotEmpty ? _buildListView() : _buildLoading(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _poets.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_poets[index].name),
          subtitle: Text(_poets[index].nickname),
          leading: Container(
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  GanjoorService.baseUrl + _poets[index].imageUrl,
                ),
              ),
            ),
          ),
        );
      },
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
